require 'graphql/client'
require 'graphql/client/http'

module GithubApi
  HTTP = GraphQL::Client::HTTP.new("https://api.github.com/graphql") do
    def headers(context)
      { "Authorization": "Bearer #{ENV['GITHUB_API_KEY']}" }
    end
  end

  Schema = GraphQL::Client.load_schema(HTTP)

  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)

  RepositoryIssuesQuery = Client.parse <<-GRAPHQL
    query($repositoryOwner: String!, $repositoryName: String!, $last: Int!) {
      repository(owner: $repositoryOwner, name: $repositoryName) {
        issues(last: $last) {
          edges {
            node {
              title
              url
              labels(first:5) {
                edges {
                  node {
                    name
                  }
                }
              }
            }
          }
        }
      }
    }
  GRAPHQL

  module_function

  def request_repository_issues(repository_owner, repository_name, last)
    Client.query(RepositoryIssuesQuery, variables: {
      repositoryOwner: repository_owner,
      repositoryName: repository_name,
      last: last
    })
  end
end
class HomeController < ApplicationController
  def index
    @owner = 'octocat'
    @repository_name = 'Hello-World'
    result = GithubApi.request_repository_issues(@owner, @repository_name, 20)

    if result.errors.blank?
      @issues = result.data.repository&.issues&.edges || []
    else
      message = result.errors.join(', ')
      render status: :internal_server_error, plain: message
    end
  end
end

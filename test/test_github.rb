require 'helper'
require 'spore/middleware/format'

class TestGitHub < Test::Unit::TestCase

  def setup
    json = File.expand_path( '../github.json', __FILE__)
    yaml = File.expand_path( '../github.yml', __FILE__)
    @specs  = [json,yaml]
  end

  def test_basic_github_search
    @specs.each do |spec|
      gh = Spore.new(spec)

      r = gh.user_search(:format => 'json', :search => 'sukria')
      assert_kind_of Net::HTTPOK, r
      assert_kind_of String, r.body
    end
  end

  def test_with_format_github_search
    @specs.each do |spec|
      gh = Spore.new(spec)

      gh.enable(Spore::Middleware::Format, :format => 'json')

      assert_equal 1, gh.middlewares.size

      r = gh.user_search(:format => 'json', :search => 'sukria')
      assert_kind_of Net::HTTPOK, r
      assert_kind_of Hash, r.body
      assert_equal 'sukria', r.body['users'][0]['name']
    end
  end

end


describe 'straptible api' do
  before :all do
    rel_tmp = '../../tmp/spec'
    @tmpdir = File.expand_path(rel_tmp, File.dirname(__FILE__))
    FileUtils.mkdir_p @tmpdir
    FileUtils.rm_rf File.join(@tmpdir, 'foobar')

    rel_straptible = '../../bin/straptible'
    @straptible = File.expand_path(rel_straptible, File.dirname(__FILE__))
  end

  context 'with no additional arguments' do
    before :all do
      `#{@straptible} api #{File.join(@tmpdir, 'foobar')} -B`
    end

    after :all do
      FileUtils.rm_r File.join(@tmpdir, 'foobar')
    end

    it 'does not include a test/ directory' do
      File.exist?(File.join(@tmpdir, 'foobar', 'test')).should be_false
    end

    it 'includes a spec/ directory' do
      File.exist?(File.join(@tmpdir, 'foobar', 'spec')).should be_true
    end

    it 'does not include a README.rdoc' do
      File.exist?(File.join(@tmpdir, 'foobar', 'README.rdoc')).should be_false
    end

    it 'includes an appropriate README.md' do
      readme = File.join(@tmpdir, 'foobar', 'README.md')
      File.exist?(readme).should be_true
      File.read(readme).should match /\#.*public\/icon-72-cropped.png.*Foobar/
    end

    it 'does not include HTML error pages' do
      Dir.glob('public/*.html').should be_empty
    end

    it 'does not include app/assets/ or app/mailers/' do
      app = File.join(@tmpdir, 'foobar', 'app')
      File.exist?(File.join(app, 'assets')).should be_false
      File.exist?(File.join(app, 'mailers')).should be_false
    end

    it 'includes app/decorators/' do
      app = File.join(@tmpdir, 'foobar', 'app')
      File.exist?(File.join(app, 'decorators')).should be_true
    end

    it 'has a spec/spec_helper.rb' do
      spec = File.join(@tmpdir, 'foobar', 'spec')
      File.exist?(File.join(spec, 'spec_helper.rb')).should be_true
    end

    it 'has a valid database.yml' do
      database_yml = File.join(@tmpdir, 'foobar', 'config', 'database.yml')
      File.exist?(database_yml).should be_true
      File.read(database_yml).should match /foobar_development/
      File.read(database_yml).should match /foobar_test/
    end

    it 'is initialized as a Git repository' do
      git_log = `cd #{File.join(@tmpdir, 'foobar')} && git log --oneline`
      git_log.should =~ /Initial commit.*#{Straptible::VERSION}/
    end

    it 'has a .travis.yml file which includes JRuby in the build matrix' do
      travis_yml = File.join(@tmpdir, 'foobar', '.travis.yml')
      File.exist?(travis_yml).should be_true
      File.read(travis_yml).should match /jruby/
    end

    it 'has a package.json for Node dependencies' do
      package_json = File.join(@tmpdir, 'foobar', 'package.json')
      File.exist?(package_json).should be_true
    end

    it 'has an initializer for the JSON-API MIME type' do
      initializers = File.join(@tmpdir, 'foobar', 'config', 'initializers')
      mime_types = File.join(initializers, 'mime_types.rb')
      File.exist?(mime_types).should be_true
      File.read(mime_types).should match /:json_api/
    end
  end

  context 'executing bundle install' do
    before :all do
      # TODO: Figure out how to do this offline
      `#{@straptible} api #{File.join(@tmpdir, 'foobar')}`
    end

    after :all do
      FileUtils.rm_rf File.join(@tmpdir, 'foobar')
    end

    it 'passes Rubocop muster' do
      `cd #{File.join(@tmpdir, 'foobar')} && bundle exec rake rubocop`
      $CHILD_STATUS.exitstatus.should == 0
    end

  end
end

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
      expect(File.exist?(File.join(@tmpdir, 'foobar', 'test'))).to eq false
    end

    it 'includes a spec/ directory' do
      expect(File.exist?(File.join(@tmpdir, 'foobar', 'spec'))).to eq true
    end

    it 'does not include a README.rdoc' do
      readme = File.join(@tmpdir, 'foobar', 'README.rdoc')
      expect(File.exist?(readme)).to eq false
    end

    it 'includes an appropriate README.md' do
      readme = File.join(@tmpdir, 'foobar', 'README.md')
      expect(File.exist?(readme)).to eq true
      expect(File.read(readme)).to match(%r{#.*public/icon-60px.png.*Foobar})
    end

    it 'does not include HTML error pages' do
      expect(Dir.glob('public/*.html')).to be_empty
    end

    it 'does not include app/assets/ or app/mailers/' do
      app = File.join(@tmpdir, 'foobar', 'app')
      expect(File.exist?(File.join(app, 'assets'))).to eq false
      expect(File.exist?(File.join(app, 'mailers'))).to eq false
    end

    it 'includes app/decorators/' do
      app = File.join(@tmpdir, 'foobar', 'app')
      expect(File.exist?(File.join(app, 'decorators'))).to eq true
    end

    it 'has a spec/spec_helper.rb' do
      spec = File.join(@tmpdir, 'foobar', 'spec')
      expect(File.exist?(File.join(spec, 'spec_helper.rb'))).to eq true
    end

    it 'has a valid database.yml' do
      database_yml = File.join(@tmpdir, 'foobar', 'config', 'database.yml')
      expect(File.exist?(database_yml)).to eq true
      expect(File.read(database_yml)).to match(/foobar_development/)
      expect(File.read(database_yml)).to match(/foobar_test/)
    end

    it 'is initialized as a Git repository' do
      git_log = `cd #{File.join(@tmpdir, 'foobar')} && git log --oneline`
      expect(git_log).to match(/Initial commit.*#{Straptible::VERSION}/)
    end

    it 'has a .travis.yml file which includes JRuby in the build matrix' do
      travis_yml = File.join(@tmpdir, 'foobar', '.travis.yml')
      expect(File.exist?(travis_yml)).to eq true
      expect(File.read(travis_yml)).to match(/jruby/)
    end

    it 'has a package.json for Node dependencies' do
      package_json = File.join(@tmpdir, 'foobar', 'package.json')
      expect(File.exist?(package_json)).to eq true
    end

    it 'has an initializer for the JSON-API MIME type' do
      initializers = File.join(@tmpdir, 'foobar', 'config', 'initializers')
      mime_types = File.join(initializers, 'mime_types.rb')
      expect(File.exist?(mime_types)).to eq true
      expect(File.read(mime_types)).to match(/:json_api/)
    end

    it 'sets config in application.rb instead of config/initializers' do
      initializers = File.join(@tmpdir, 'foobar', 'config', 'initializers')
      filter_parameters = File.join(initializers, 'filter_parameters.rb')
      expect(File.exist?(filter_parameters)).to eq false

      application = File.join(@tmpdir, 'foobar', 'config', 'application.rb')
      expect(File.exist?(application)).to eq true
      expect(File.read(application)).to match(/filter_parameters/)
    end

    it 'includes auto_annotate_models.rake' do
      tasks = File.join(@tmpdir, 'foobar', 'lib', 'tasks')
      auto_annotate = File.join(tasks, 'auto_annotate_models.rake')
      expect(File.exist?(auto_annotate)).to eq true
    end

    it 'loads Annotate tasks' do
      rakefile = File.join(@tmpdir, 'foobar', 'Rakefile')
      expect(File.read(rakefile)).to match(/Annotate.load_tasks/)
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
      Bundler.with_clean_env do
        `cd #{File.join(@tmpdir, 'foobar')} && bundle exec rake rubocop`
      end
      expect($CHILD_STATUS.exitstatus).to eq 0
    end
  end
end

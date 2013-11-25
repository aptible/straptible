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
      File.read(readme).should match /\#.*public\/icon-72.png.*Foobar/
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
      `cd #{File.join(@tmpdir, 'foobar')} && rake rubocop`
      $CHILD_STATUS.exitstatus.should == 0
    end

  end
end

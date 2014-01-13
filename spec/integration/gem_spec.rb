describe 'straptible gem' do
  before :all do
    rel_tmp = '../../tmp/spec'
    @tmpdir = File.expand_path(rel_tmp, File.dirname(__FILE__))
    FileUtils.mkdir_p @tmpdir
    FileUtils.rm_rf File.join(@tmpdir, 'foobar')

    rel_straptible = '../../bin/straptible'
    @straptible = File.expand_path(rel_straptible, File.dirname(__FILE__))
  end

  context 'with a simple gem name' do
    before :all do
      `#{@straptible} gem #{File.join(@tmpdir, 'foobar')}`
    end

    after :all do
      FileUtils.rm_r File.join(@tmpdir, 'foobar')
    end

    it 'includes an appropriate README.md' do
      readme = File.join(@tmpdir, 'foobar', 'README.md')
      File.exist?(readme).should be_true
      File.read(readme).should match(/\#.*icon-60px.png.*Foobar/)
    end
  end

  context 'with a complex gem name' do
    before :all do
      `#{@straptible} gem #{File.join(@tmpdir, 'foobar/foo_bar-baz')}`
    end

    after :all do
      FileUtils.rm_r File.join(@tmpdir, 'foobar')
    end

    it 'includes an appropriate gemspec' do
      gemdir = File.join(@tmpdir, 'foobar', 'foo_bar-baz')
      gemspec = File.join(gemdir, 'foo_bar-baz.gemspec')
      File.exist?(gemspec).should be_true
      File.read(gemspec).should match(/FooBar::Baz/)
    end
  end

  context 'executing bundle install' do
    before :all do
      # TODO: Figure out how to do this offline
      `#{@straptible} gem #{File.join(@tmpdir, 'foobar')}`
      `cd #{File.join(@tmpdir, 'foobar')} && bundle install`
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

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
      expect(File.exist?(readme)).to eq true
      expect(File.read(readme)).to match(/\#.*icon-60px.png.*Foobar/)
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
      expect(File.exist?(gemspec)).to eq true
      expect(File.read(gemspec)).to match(/FooBar::Baz/)
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
      expect($CHILD_STATUS.exitstatus).to eq 0
    end
  end
end

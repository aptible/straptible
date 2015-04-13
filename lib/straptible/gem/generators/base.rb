require 'thor'
require 'bundler'

module Straptible
  module Gem
    module Generators
      class Base < Thor
        include Thor::Actions

        attr_accessor :name, :opts

        def self.start
          tmpl_path = File.join('..', 'templates')
          source_root File.expand_path(tmpl_path, File.dirname(__FILE__))

          super
        end

        no_commands do
          def git_name
            `git config user.name`.chomp
          end

          def author
            git_name.empty? ? 'TODO: Write your name' : git_name
          end

          def git_email
            `git config user.email`.chomp
          end

          def email
            git_email.empty? ? 'TODO: Write your email address' : git_email
          end

          def namespaced_path
            name.tr('-', '/')
          end

          def constant_name
            cn = name.split('_').map(&:capitalize).join
            if cn =~ /-/
              cn.split('-').map { |q| q[0..0].upcase + q[1..-1] }.join('::')
            else
              cn
            end
          end

          def constant_array
            constant_name.split('::')
          end

          def commit_message
            "Initial commit (Straptible #{Straptible::VERSION})"
          end

          def git_init
            inside destination_root do
              run 'git init .'
              run 'git add .'
              run "git commit -m '#{commit_message}'"
            end
          end
        end

        # rubocop:disable MethodLength
        desc 'gem NAME', 'Creates an Aptible-configured Ruby gem'
        def gem(name_or_path)
          self.destination_root = File.expand_path(name_or_path, Dir.pwd)
          self.name = File.basename(name_or_path)

          self.opts = {
            name: name,
            namespaced_path: namespaced_path,
            constant_name: constant_name,
            constant_array: constant_array,
            author: author,
            email: email
          }

          template 'Gemfile.tt', opts
          template 'LICENSE.md.tt', opts
          template 'README.md.tt', opts
          template 'newgem.gemspec.tt', "#{name}.gemspec", opts
          template 'spec/spec_helper.rb.tt', 'spec/spec_helper.rb', opts

          template 'lib/newgem.rb.tt', "lib/#{namespaced_path}.rb", opts
          template 'lib/newgem/version.rb.tt',
                   "lib/#{namespaced_path}/version.rb", opts

          copy_file 'Rakefile'
          copy_file 'gitignore', '.gitignore'
          copy_file 'rspec', '.rspec'
          copy_file 'travis.yml', '.travis.yml'

          git_init
        end
        # rubocop:enable MethodLength
      end
    end
  end
end

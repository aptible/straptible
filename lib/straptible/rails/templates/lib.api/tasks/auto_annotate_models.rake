if Rails.env.development?
  task :set_annotation_options do
    ENV['position_in_class']    = 'before'
    ENV['position_in_test']     = 'before'
    ENV['position_in_factory']  = 'before'
    ENV['show_indexes']         = 'false'
    ENV['include_version']      = 'false'
    ENV['exclude_tests']        = 'true'
    ENV['exclude_factories']    = 'false'
    ENV['ignore_model_sub_dir'] = 'false'
    ENV['skip_on_db_migrate']   = 'false'
  end

  Rake::Task['db:migrate'].enhance do
    Rake::Task[:annotate_models].invoke
  end

  Rake::Task['db:rollback'].enhance do
    Rake::Task[:annotate_models].invoke
  end
end

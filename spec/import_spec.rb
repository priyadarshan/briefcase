require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Shhh::Commands::Import do

  before do
    setup_work_directories
    @original_path = File.join(home_path, '.test')
    @destination_path = File.join(dotfiles_path, 'test')
  end

  after do
    cleanup_work_directories
  end

  it "does not import a nonexistent dotfile" do
    run_command("import .test")
    output_must_contain(/does not exist/)
  end
  
  it "imports a dotfile" do
    create_empty_file(@original_path)

    run_command("import #{@original_path}")

    output_must_contain(/Importing/, /Moving/)
    file_must_have_moved(@original_path, @destination_path)
    symlink_must_exist(@original_path, @destination_path)
  end
  
  it "imports a dynamic dotfile" do
    dynamic_path = File.join(dotfiles_path, 'test.erb')
    create_empty_file(@original_path)

    run_command("import #{@original_path} --erb")

    output_must_contain(/Importing/, /Moving/, /Creating ERB version at/)
    file_must_have_moved(@original_path, @destination_path)
    symlink_must_exist(@original_path, @destination_path)
    file_must_have_moved(@original_path, dynamic_path)
  end
  
  describe "collision handling" do
    
    before do
      @relocated_path = File.join(dotfiles_path, 'test.old.1')
      create_empty_file(@original_path)
      create_empty_file(@destination_path)
    end
    
    it "renames an existing dotfile when importing a duplicate and instructed to replace it" do
      run_command("import #{@original_path}") do |c|
        c.response(/Do you want to replace it\?/, 'replace')
      end

      output_must_contain(/Moving/, /Symlinking/, /already exists as a dotfile/)
      file_must_exist(@destination_path)
      file_must_exist(@relocated_path)
      symlink_must_exist(@original_path, @destination_path)
    end
    
    it "renames an existing duplicate dotfile when importing a duplicate and instructed to replace it" do
      duplicate_path = File.join(dotfiles_path, 'test.old.2')
      create_empty_file(@relocated_path)

      run_command("import #{@original_path}") do |c|
        c.response(/Do you want to replace it\?/, 'replace')
      end
      
      file_must_have_moved(@destination_path, duplicate_path)
      file_must_not_have_moved(@relocated_path)
    end
  
    it "does not modify an existing dotfile when instructed not to" do
      run_command("import #{@original_path}") do |c|
        c.response(/Do you want to replace it\?/, 'skip')
      end

      output_must_contain(/already exists as a dotfile/)
      output_must_not_contain(/Moving/, /Symlinking/)
      file_must_not_have_moved(@original_path)
      file_must_not_have_moved(@destination_path)
      file_must_not_exist(@relocated_path)
      symlink_must_not_exist(@original_path)
    end
    
  end
end
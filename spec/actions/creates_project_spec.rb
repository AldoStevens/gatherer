require "rails_helper"

describe "task string parsing" do
  let(:creator) { CreatesProject.new(name: "Test", task_string: task_string) }
  let(:tasks) { creator.convert_string_to_tasks }


  describe "with an empty string" do
    let(:task_string) { "" }
    specify { expect(tasks.size).to eq(0) }
  end

  describe "with a single string" do 
   let(:task_string) { "Start things" }
   specify { expect(tasks.size).to eq(1) }
   specify { expect(tasks.map(&:title)).to eq(["Start things"]) }
   specify { expect(tasks.map(&:size)).to eq([1]) }
  end

  describe "with a single string with size" do 
    let(:task_string) { "Start things: 3" }
    specify { expect(tasks.size).to eq(1) }
    specify { expect(tasks.map(&:title)).to eq(["Start things"]) }
    specify { expect(tasks.map(&:size)).to eq([3]) } 
  end

  it "with multiple tasks" do 
    creator = CreatesProject.new(name: "Test", task_string: "Start things:3\nEnd things:2")
    tasks = creator.convert_string_to_tasks
    expect(tasks).to match([
      an_object_having_attributes(title: "Start things", size: 3),
      an_object_having_attributes(title: "End things", size: 2)])
  end

  describe "attaching tasks to the project" do 
    let(:task_string) { "Start things:3\nEnd things:2" }
    it "saves the project and tasks" do 
      creator.create 
      expect(creator.project.tasks.size).to eq(2)
      expect(creator.project).not_to be_a_new_record
    end
  end
end

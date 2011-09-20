require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Benford do

  describe "after loading" do
    
    before(:each) do
     @b = Benford.new
    end
    
    it "counts the correct numbers" do
       @b.load! ["6712", "1232"]
       @b.numbers.count.should == 2
    end
     
    it "counts floats" do
      @b.load! ["6712", "65123.1", "1232"]
      @b.numbers.count.should == 3
    end

    it "strips strings" do
      @b.load! ["6712345", "kjaadish", "2713678"]
      @b.numbers.count.should == 2  
    end
    
    it "converts a 1 < float into an integer" do
      @b.load! ["0.123"]
      @b.numbers.first.first.should == "1" # first.first is confusing, but alas
    end
    
    it "does not skip commas in numbers" do
      @b.load! ["123,212.1"]
      @b.numbers.count.should == 1
    end
    
    it "get the counts per number right" do
      @b.load! ["18213", "2187356", "2131234", "2131234"]
      @b.counts["1"].should == 1
      @b.counts["2"].should == 3
    end
    
    it "gets the right distribution" do
      @b.load! ["18213", "1187356", "2131234", "2131234"]
      @b.distribution["1"].should == 0.5
      @b.distribution["2"].should == 0.5
    end
    
    it "also get another distribution" do
      @b.load! ["111", "111", "111", "222"]
      @b.distribution["1"].should == 0.75 
      @b.distribution["2"].should == 0.25 
    end

    it "and another distribution" do
      @b.load! ["1"]
      @b.distribution["1"].should == 1
    end
    
    it "gets the correct variant from the distribution" do
      @b.load! ["111", "111", "222", "222"]
      @b.deviation["1"].should be_between 0.19, 0.2
      @b.deviation["2"].should be_between 0.32, 0.33
    end
  end
end
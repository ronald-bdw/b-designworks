module Users
  class SplittedName
    attr_reader :first_name, :last_name

    def initialize(full_name)
      @first_name, @last_name = full_name.split(" ", 2)
    end

    def to_hash
      { first_name: first_name, last_name: last_name }
    end
  end
end

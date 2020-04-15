#!/usr/bin/ruby

module Enumerable
    def my_each(&block)
        i = 0

        until i == self.length do
            yield(self[i])
            i += 1
        end

        self
    end

    def my_each_with_index(&block)
        i = 0

        until i == self.length do
            yield(self[i], i)
            i += 1
        end

        self
    end

    def my_select(&block)
        selected = []

        self.my_each do |item|
            selected.push(item) if yield(item)
        end

        selected
    end

    def my_all?(&block)
        self.my_each do |item|
            return false if !yield(item)
        end

        true
    end

    def my_any?(&block)
        self.my_each do |item|
            return true if yield(item)
        end

        false
    end

    def my_none?(&block)
        self.my_each do |item|
            return false if yield(item)
        end

        true
    end

    def my_count(target=nil, &block)
        if target == nil && !block_given?
            self.length
        elsif target != nil && !block_given?
            self.my_select {|item| item == target}.length
        else
            self.my_select(&block).length
        end
    end

    def my_map(my_proc=nil, &block)
        self.my_each_with_index do |item, index|
            if my_proc
                self[index] = my_proc.call(item)
            else
                self[index] = yield(item)
            end
        end

        self
    end

    def my_inject(symbol=nil, &block)
        total = self[0]

        self.my_each do |item|
            next if item == self[0]

            if block_given?
                total = yield(total, item)
            else
                total = total.send(symbol, item)
            end
        end

        total
    end

end

cube = Proc.new {|x| x**3}
puts [1, 2, 3].my_map_with_proc(cube) {|x| x*2}
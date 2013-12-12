require "ratex/version"

module Ratex
    extend self

    #one character constant
    ('A'..'Z').each do |c|
        const_set(c, c)
    end

    class Generator

        OPERATORS = [:+, :-, :*, :/, :**, :==, :+@, :-@, :<, :>]
        KLASSES = [Fixnum, String, Symbol]

        def begin_generate
            return if @generate_ready

            KLASSES.each do |klass|
                klass.class_eval do
                    OPERATORS.each do |ope|
                        if method_defined? ope
                            alias_method "#{ope}_", ope
                        end
                    end

                    [:+, :-, :<, :>].each do |ope|
                        define_method(ope) do |other|
                            "#{self} #{ope} #{other}"
                        end
                    end

                    def **(other)
                        "#{self} ^{#{other}}"
                    end

                    def *(other)
                        "#{self} #{other}"
                    end

                    def /(other)
                        "\\frac{#{self}}{#{other}}"
                    end

                    def +@
                        "+#{self}"
                    end

                    def -@
                        "-#{self}"
                    end

                    def ==(other)
                        "#{self} = #{other}"
                    end
                end
            end

            @generate_ready = true
        end

        def finish_generate
            return unless @generate_ready

            KLASSES.each do |klass|
                klass.class_eval do
                    OPERATORS.each do |ope|
                        remove_method ope
                        if method_defined? "#{ope}_"
                            alias_method ope, "#{ope}_"
                        end
                    end
                end
            end

            @generate_ready = false
        end

        def out_of_generate
            finish_generate
            ret = yield
            begin_generate
            ret
        end

        class Context

            def initialize(gen)
                @gen = gen
            end

            #keywords
            [:pi, :theta].each do |keyword|
                define_method(keyword) do
                    "\\#{keyword}"
                end
            end

            def sqrt(expr, n = 2)
                @gen.out_of_generate do
                    "\\sqrt" + ((n != 2)? "[#{n}]" : "") + "{#{expr.to_s}}"
                end
            end

            def sum(init, max, expr)
                "\\sum^{#{max}}_{#{init}} #{expr}"
            end

            def fact(expr)
                "(#{expr})!"
            end

            def b1(expr)
                "(#{expr})"
            end

            def b2(expr)
                "{#{expr}}"
            end

            def b3(expr)
                "[#{expr}]"
            end

            [:sin, :cos, :tan].each do |func|
                define_method(func) do |expr|
                    "\\#{func}(#{expr})"
                end
            end

            def [](expr)
                "[#{expr}]"
            end

            def method_missing(name, *args)
                @gen.out_of_generate do
                    ret = name.to_s

                    if args.size != 0
                        ret << "(#{args.join(', ')})"
                    end

                    ret.instance_eval do
                        def [](index)
                            "#{self}_{#{index}}"
                        end
                    end

                    ret
                end
            end
        end

        def generate(&block)
            begin_generate

            context = Context.new(self)
            ret = context.instance_eval(&block).to_s

            finish_generate

            ret
        end
    end

    def generate(&block)
        gen = Generator.new

        "$$#{gen.generate(&block)}$$"
    end
end

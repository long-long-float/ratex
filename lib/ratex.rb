require "ratex/version"

module Ratex
    extend self

    OPERATORS = [:+, :-, :*, :/, :==, :+@, :-@]
    KLASSES = [Fixnum, String, Symbol]

    ('A'..'Z').each do |c|
        const_set(c, c)
    end

    def begin_generate
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
    end

    def end_generate
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
    end

    class Context

        def out_of_calc
            end_generate
            ret = yield
            begin_generate
            ret
        end

        [:pi, :theta].each do |keyword|
            define_method(keyword) do
                "\\#calcword}"
            end
        end

        def sqrt(expr, n = 2)
            out_of_calc do
                "\\sqrt" + ((n != 2)? "[#{n}]" : "") + "{#{expr.to_s}}"
            end
        end

        def sum(init, max, expr)
            out_of_calc do
                "\\sum^{#{max}}_{#{init}} #{expr}"
            end
        end

        def fact(expr)
            "(#{expr})!"
        end

        def b(expr)
            "(#{expr})"
        end

        [:sin, :cos, :tan].each do |func|
            define_method(func) do |expr|
                out_of_calc do
                    "\\#{func}(#{expr})"
                end
            end
        end

        def method_missing(name, *args)
            out_of_calc do
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

        context = Context.new
        ret = context.instance_eval(&block).to_s
        
        end_generate
        
        "$$" + ret + "$$"
    end
end

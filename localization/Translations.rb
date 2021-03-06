
# Copyright (c) 2021 [hds536jhmk](https://github.com/hds536jhmk/pemu-RubyProcessor)
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR

require "PEMUJRubyPluginAPI"
require "singleton"

java_import Java::JavaIo::FileReader
java_import Java::JavaNioFile::Paths

class Translations
public
    # This is an ITranslatable, meaning that it can receive translation updates
    include PEMU::ITranslatable
    # This is a Singleton so there's only one instance of this class
    include Singleton
    # Adding public read access to current_translation
    attr_reader :current_translation

    # Implementing method from ITranslatable
    def updateTranslations(translation)
        self.current_translation = Translations.get_plugin_translation translation
    end

protected
    # Adding protected writing access to current_translation
    attr_writer :current_translation

    def initialize()
        self.current_translation = Translations.get_plugin_translation PEMU::get_current_translation
        PEMU::TranslationManager.addTranslationListener self
    end

    # Function that merges source with this Plugin's Translation
    # @param [PEMU::Translation] source The source traslation
    # @return [PEMU::Translation] The source translation merged with this plugin's or source if there's no translation from this plugin
    def self.get_plugin_translation(source)
        plugin_translation = PEMU::parse_translation! __dir__, PEMU::get_translation_file_name( source )
        return source if plugin_translation == nil
        return PEMU::merge_translations source, plugin_translation
    end
end

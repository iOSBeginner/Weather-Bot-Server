require 'simple-rss'
require 'open-uri'
require 'nokogiri'

require './DB/connect_database.rb'


class Subscribe_Table < ActiveRecord::Base
    self.table_name = "subscribe_table"
    def add user, location
        s = Subscribe_Table.new(user: user, location: location)
        s.save!
    end

    def read user
        s = Subscribe_Table.where(user: user)
        return s
    end

    def read_all
        s = Subscribe_Table.all
        return s
    end

    def delete user, location
        s = Subscribe_Table.find_by(user: user, location: location)
        s.destroy
    end
end

class Warning_Table < ActiveRecord::Base
    self.table_name = "warning_table"
    def add user
        w = Warning_Table.new(user: user)
        w.save!
    end

    def delete user
        w = Warning_Table.find_by(user: user)

        if w
            w.destroy
        end
    end
    
    def read
        return Warning_Table.all
    end
end

class ObserveWarning_Table < ActiveRecord::Base
    self.table_name = "observeWarning_table"
    def update t
        o = ObserveWarning_Table.all
        
        if o.count > 0
            o = ObserveWarning_Table.first
            o.dispatche_time = t
            o.save!
        else
            o = ObserveWarning_Table.new(dispatche_time: t)
            o.save!
        end
        
        return o
    end
    
    def read
        return ObserveWarning_Table.all
    end
end

class Language_Table < ActiveRecord::Base
    self.table_name = "language_table"
    def read user_id
        l = Language_Table.find_by(user: user_id)
        if l
            return l.language
        else
            return "English"
        end
    end

    def update user_id, language
        l = Language_Table.find_by(user: user_id)
        if l
            l.language = language
            l.save!
        else
            l = Language_Table.new(user: user_id, language: "#{language}")
            l.save!
        end
    end
end

class Translation_Table < ActiveRecord::Base
    self.table_name = "translation_table"
    def traslate index, language
        t = Translation_Table.find_by(id: index)
        case language
        when "English"
            return t.english
        when "繁體中文"
            return t.traditional_chinese
        when "简体中文"
            return t.simplified_chinese
        end
    end

    def identifyIndex location, language
        t = Translation_Table.all
        t.each_with_index { |item, index|
            case language
            when "English"
                if t[index].english == location
                    return index + 1
                end
            when "繁體中文"
                if t[index].traditional_chinese == location
                    return index + 1
                end
            when "简体中文"
                if t[index].simplified_chinese == location
                    return index + 1
                end
            end
        }
    end
end

require './DB/database.rb'

class Model
    def fetchNewData datatype
        f = FetchDataClass.new
        a = f.nokogiri(f.rss, "weather", datatype)
        return a
    end

    def changeLanguage language
        l = Language.new
        l.update(language)
    end

    def subscribe user, location
        s = SubscribeClass.new
        s.add(user, location)
    end

    def unsubscribe_show user
        s = SubscribeClass.new
        return s.read(user)
    end
end

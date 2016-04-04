#models/quote

class Quote
    include DataMapper::Resource

    property :id, Serial
    property :text, String, required: true
    property :date, DateTime
    property :sources, PgArray
    property :poster, String, required: true, length: 1...9

    def self.groot_path=(path)
        @groot_path = path
    end
    def self.groot_path
        @groot_path
    end

    def self.is_valid_quote?(poster, text)
        if !(text =~ /^\s*$/).nil?
            return -1
        end
        if !verify_user(poster)
            return -2
        end
        return 0
    end

    def self.verify_user(user)
        if user.nil?
            return false
        end
        url = Quote.groot_path + 'users/' + user
        uri = URI(url)
        resp = Net::HTTP.get_response(uri)
        p resp.code
        if resp.code == '200'
            return true
        else
            return false
        end
    end
end

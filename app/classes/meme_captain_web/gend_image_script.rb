module MemeCaptainWeb
  # Generate a shell script that can recreate an image using the API.
  class GendImageScript
    attr_reader :endpoint

    # rubocop:disable Metrics/LineLength
    Template = <<-ERB.freeze
# shell script to recreate this image using the API
# add -H 'Authorization: Token token="<your API token>"' to use an API token
STATUS_URL=$(cat << EOS | curl -d @- -H 'Content-Type: application/json' -H 'Accept: application/json' -s <%= endpoint %> | jq -r .status_url
<%= json %>
EOS)
for i in $(seq 10); do
  case $(curl -I -o /dev/null -s -w '%{http_code}' $STATUS_URL) in
    303) curl -L -s $STATUS_URL; break;;
    200) sleep 3;;
    *) exit 1
  esac
done
ERB
    # rubocop:enable Metrics/LineLength

    def initialize(gend_image, endpoint)
      @gend_image = gend_image
      @endpoint = endpoint
    end

    def script
      ERB.new(Template).result(binding)
    end

    private

    def json
      GendImageApiRequestJson.new(@gend_image).json
    end
  end
end

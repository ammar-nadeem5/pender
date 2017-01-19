module MediaDropboxItem
  extend ActiveSupport::Concern

  URLS = [
    /^https?:\/\/(www\.)?dropbox\.com\/s\/([^\/]+)/,
    /^https?:\/\/(dl\.)?dropboxusercontent\.com\/s\/([^\/]+)/
  ]

  included do
    Media.declare('dropbox_item', URLS)
  end

  def data_from_dropbox_item
    handle_exceptions(RuntimeError) do
      self.parse_from_dropbox_html
      self.data['title'] = get_title_from_url if data['title'].blank?
      self.data['description'] = 'Shared with Dropbox' if data['description'].blank?
      self.data.merge!({
        html: html_for_dropbox_item,
      })
    end
  end

  def parse_from_dropbox_html
    metatags = { title: 'og:title', picture: 'og:image', description: 'og:description' }
    data.merge!(get_html_metadata('property', metatags))
    self.data['author_url'] = top_url(self.url)
  end

  def get_title_from_url
    uri = URI.parse(self.url)
    uri.path.split('/').last
  end

  def dropbox_dl
    self.url.gsub(/:\/\/www\.dropbox\./, '://dl.dropbox.')
  end

  def html_for_dropbox_item
    '<object data="' + dropbox_dl + '"></object>'
  end

end

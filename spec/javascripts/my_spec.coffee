describe 'my', ->
  beforeEach ->
    loadFixtures 'my.html'
    window.api_token_init()

  describe 'when the API token button is clicked', ->
    it 'sends an AJAX request', ->
      spyOn($, 'post')
      $('.api-token-button').click()
      expect($.post).toHaveBeenCalledWith('/api_token', jasmine.any(Function))

    it 'shows the user the new token', ->
      spyOn($, 'post').and.callFake (url, success) ->
        success(token: 'secret')

      $('.api-token-button').click()
      expect($('.api-token').text()).toEqual('secret')

describe 'terminal log', ->
  describe 'TerminalLog', ->
    beforeEach ->
      loadFixtures 'terminal_log.html'

    describe '#info', ->
      it 'adds text wrapped in a terminal-info class span', ->
        terminal_log = new TerminalLog $('#terminal-log')
        terminal_log.info('info test')
        expect($('#terminal-log').html()).toMatch(
          '<span class="terminal-date">\\d{2}:\\d{2}:\\d{2}\\.\\d{3}</span> ' +
          '<span class="terminal-info">info test</span><br>')

      describe 'when the text contains HTML', ->
        it 'escapes the HTML', ->
          terminal_log = new TerminalLog $('#terminal-log')
          terminal_log.info('<script>alert("hi")</script>')
          expect($('#terminal-log').html()).toMatch(
            '<span class="terminal-date">\\d{2}:\\d{2}:\\d{2}\\.\\d{3}' +
            '</span> <span class="terminal-info">' +
            '&lt;script&gt;alert\\("hi"\\)&lt;/script&gt;</span><br>')

    describe '#error', ->
      it 'adds text wrapped in a terminal-error class span', ->
        terminal_log = new TerminalLog $('#terminal-log')
        terminal_log.error('error test')
        expect($('#terminal-log').html()).toMatch(
          '<span class="terminal-date">\\d{2}:\\d{2}:\\d{2}\\.\\d{3}</span> ' +
          '<span class="terminal-error">error test</span><br>')

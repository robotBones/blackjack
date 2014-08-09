class window.AppView extends Backbone.View

  className: "app"


  template: _.template '
    <div class="btns"><button class="hit-button">Hit</button> <button class="stand-button">Stand</button></div>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
    <div class="deck"></div>
  '

  events:
    "click .hit-button": ->
      @model.get('playerHand').hit()
      @render()
    "click .stand-button": ->
      @model.get('playerHand').stand()
      @render()
    "click .play-button": ->
      console.log("playing")
      @model.nextRound()
      @render()

  initialize: ->
    @render()
    @model.on "noControl", =>
      # the only hack I could find to diable the buttons on dealers turn
      @template = _.template '
        <div class="btns"><button class="play-button">Play</button></div>
        <div class="player-hand-container"></div>
        <div class="dealer-hand-container"></div>
        <div class="deck"></div>
      '

    @model.on "control", =>
      # the only hack I could find to diable the buttons on dealers turn
      @template = _.template '
        <div class="btns"><button class="hit-button">Hit</button> <button class="stand-button">Stand</button></div>
        <div class="player-hand-container"></div>
        <div class="dealer-hand-container"></div>
        <div class="deck"></div>
      '

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    @$('.deck').html("<h2>Cards in Deck left (" + @model.get('deck').length + ")</h2>");
class window.AppView extends Backbone.View

  className: "app"


  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
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

  initialize: ->
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    @$('.deck').html("<h2>Cards in Deck left (" + @model.get('deck').length + ")</h2>");
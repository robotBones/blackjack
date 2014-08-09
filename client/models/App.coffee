#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  # initialization of the game. deck.dealPlayer() produces hand collections.
  initialize: ->
    # App model wraps all other models as properties.
    # as properties they have to be accesed via setters/getters
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

    # listening to hand collections
    #
    # end game instigator 1 of 4
    # listens whether deck is empty
    # if so then end game
    @get('deck').on 'change', (hand)=>
      if @get('deck').length is 0
        endGame(hand)

    # end game instigator 2 of 4
    # when player stands the turn goes to dealer
    # when dealer stands that ends the game
    @get('playerHand').on 'stand', (hand)=>
      console.log "player stands"
      @dealerStartTurn()
    @get('dealerHand').on 'stand', (hand)=>
      console.log "dealer stands"
      @endGame(hand)

    # end game instigator 3 of 4
    # when a hand's score is over 21 it busts
    @get('playerHand').on 'bust', (player)=>
      console.log "App heard the player busted"
      @endGame(player, 'bust')
    @get('dealerHand').on 'bust', (dealer)=>
      console.log "App heard the dealer busted"
      @endGame(dealer, 'bust')

    # end game instigator 4 of 4
    # someone gets a black jack (10, Ace)


  # end of initialize ->

  # game logic
  endGame: (hand, message)->
    status = "yay!"

    if message is "bust" and hand.isDealer
      status = "dealer busts"
    else if message is "bust" and not hand.dealer
      status = "player busts"

    console.log "end of game #{status}"

  dealerStartTurn: ->
    console.log "dealers starts turn"
    dealer = @get('dealerHand')

    # dealer reveals hidden card
    dealer.at(0).flip()

    while dealer.getScore() < 17
      dealer.hit() # dealer hits until condition instigates end game

    #dealer hits on soft 17
    while dealer.hasSoftScore() and dealer.getScore() is 17
      dealer.hit
    dealer.evalScore()
    dealer.stand() # has to stand or bust which then proceeds to end game

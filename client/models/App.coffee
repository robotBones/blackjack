#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  # initialization of the game. deck.dealPlayer() produces hand collections.
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @get('playerHand').on 'stand', ()=>
      @dealerStartTurn()
    @get('dealerHand').on 'stand', ()=>
      @checkWinner()
    @get('playerHand').on 'bust', (player)=>
      console.log "bust"
      @bust(player)
    @get('dealerHand').on 'bust', (dealer)=>
      @bust(dealer)
  # listening to hand collections
  endTurn: ->
    null

  bust: (hand)->
    console.log('bust')
    hand.winState = 'Bust'
    if hand == @get('playerHand') then @get('dealerHand').wins() else hand.wins()
    @ends()

  dealerStartTurn: ->
    dh = @get('dealerHand')
    dh.at(0).flip()
    while dh.getScore() < 17
      dh.hit()
    dh.stand() # has to stand

  checkWinner: ->
    console.log("everyone wins!")
    dealer = @get('dealerHand')
    player = @get('playerHand')
    if dealer.getScore() > player.getScore() then dealer.wins() else player.wins()
    @ends()

  ends: ->
    alert "yay, someone won!"

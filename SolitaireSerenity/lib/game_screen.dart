import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:solitaire/card_column.dart';
import 'package:solitaire/empty_card.dart';
import 'package:solitaire/playing_card.dart';
import 'package:solitaire/transformed_card.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Stores the cards on the seven columns
  List<PlayingCard> cardColumn1 = [];
  List<PlayingCard> cardColumn2 = [];
  List<PlayingCard> cardColumn3 = [];
  List<PlayingCard> cardColumn4 = [];
  List<PlayingCard> cardColumn5 = [];
  List<PlayingCard> cardColumn6 = [];
  List<PlayingCard> cardColumn7 = [];

  // Stores the card deck
  List<PlayingCard> cardDeckClosed = [];
  List<PlayingCard> cardDeckOpened = [];

  // Stores the card in the upper boxes
  List<PlayingCard> finalHeartsDeck = [];
  List<PlayingCard> finalDiamondsDeck = [];
  List<PlayingCard> finalSpadesDeck = [];
  List<PlayingCard> finalClubsDeck = [];

  bool winLose = false;

  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;

  String _result = '00:00:00';

  @override
  void initState() {
    super.initState();
    _start();
    _initialiseGame();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/langit.png'),
                // Replace with the actual path to your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            // Make sure the Scaffold is transparent
            appBar: AppBar(
              title: const Text("Solitaire Serenity"),
              elevation: 5.0,
              backgroundColor: Colors.blue,
              actions: <Widget>[
                InkWell(
                  splashColor: Colors.white,
                  onTap: () {
                    winLoseFunction(false);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            body: Container(
              margin: const EdgeInsets.all(16.0),
              // Add margin to the entire Column
              child: Column(
                // Add margin to the entire Column
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildCardDeck(),
                      _buildFinalDecks(),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: CardColumn(
                          cards: cardColumn1,
                          onCardsAdded: (cards, index) {
                            setState(() {
                              cardColumn1.addAll(cards);
                              int? length = _getListFromIndex(index)?.length;
                              _getListFromIndex(index)
                                  ?.removeRange(length! - cards.length, length);
                              _refreshList(index);
                            });
                          },
                          columnIndex: 1,
                        ),
                      ),
                      Expanded(
                        child: CardColumn(
                          cards: cardColumn2,
                          onCardsAdded: (cards, index) {
                            setState(() {
                              cardColumn2.addAll(cards);
                              int? length = _getListFromIndex(index)?.length;
                              _getListFromIndex(index)
                                  ?.removeRange(length! - cards.length, length);
                              _refreshList(index);
                            });
                          },
                          columnIndex: 2,
                        ),
                      ),
                      Expanded(
                        child: CardColumn(
                          cards: cardColumn3,
                          onCardsAdded: (cards, index) {
                            setState(() {
                              cardColumn3.addAll(cards);
                              int? length = _getListFromIndex(index)?.length;
                              _getListFromIndex(index)
                                  ?.removeRange(length! - cards.length, length);
                              _refreshList(index);
                            });
                          },
                          columnIndex: 3,
                        ),
                      ),
                      Expanded(
                        child: CardColumn(
                          cards: cardColumn4,
                          onCardsAdded: (cards, index) {
                            setState(() {
                              cardColumn4.addAll(cards);
                              int? length = _getListFromIndex(index)?.length;
                              _getListFromIndex(index)
                                  ?.removeRange(length! - cards.length, length);
                              _refreshList(index);
                            });
                          },
                          columnIndex: 4,
                        ),
                      ),
                      Expanded(
                        child: CardColumn(
                          cards: cardColumn5,
                          onCardsAdded: (cards, index) {
                            setState(() {
                              cardColumn5.addAll(cards);
                              int? length = _getListFromIndex(index)?.length;
                              _getListFromIndex(index)
                                  ?.removeRange(length! - cards.length, length);
                              _refreshList(index);
                            });
                          },
                          columnIndex: 5,
                        ),
                      ),
                      Expanded(
                        child: CardColumn(
                          cards: cardColumn6,
                          onCardsAdded: (cards, index) {
                            setState(() {
                              cardColumn6.addAll(cards);
                              int? length = _getListFromIndex(index)?.length;
                              _getListFromIndex(index)
                                  ?.removeRange(length! - cards.length, length);
                              _refreshList(index);
                            });
                          },
                          columnIndex: 6,
                        ),
                      ),
                      Expanded(
                        child: CardColumn(
                          cards: cardColumn7,
                          onCardsAdded: (cards, index) {
                            setState(() {
                              cardColumn7.addAll(cards);
                              int? length = _getListFromIndex(index)?.length;
                              _getListFromIndex(index)
                                  ?.removeRange(length! - cards.length, length);
                              _refreshList(index);
                            });
                          },
                          columnIndex: 7,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the deck of cards left after building card columns
  Widget _buildCardDeck() {
    return Row(
      children: <Widget>[
        InkWell(
          child: cardDeckClosed.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TransformedCard(
                    playingCard: cardDeckClosed.last,
                    columnIndex: null,
                    attachedCards: [],
                  ),
                )
              : Opacity(
                  opacity: 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TransformedCard(
                      playingCard: PlayingCard(
                        cardSuit: CardSuit.diamonds,
                        cardType: CardType.five,
                      ),
                      columnIndex: null,
                      attachedCards: [],
                    ),
                  ),
                ),
          onTap: () {
            setState(() {
              if (cardDeckClosed.isEmpty) {
                cardDeckClosed.addAll(cardDeckOpened.map((card) {
                  return card
                    ..opened = false
                    ..faceUp = false;
                }));
                cardDeckOpened.clear();
              } else {
                cardDeckOpened.add(
                  cardDeckClosed.removeLast()
                    ..faceUp = true
                    ..opened = true,
                );
              }
            });
          },
        ),
        cardDeckOpened.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(4.0),
                child: TransformedCard(
                  playingCard: cardDeckOpened.last,
                  attachedCards: [
                    cardDeckOpened.last,
                  ],
                  columnIndex: 0,
                ),
              )
            : Container(
                width: 40.0,
              ),
      ],
    );
  }

  // Build the final decks of cards
  Widget _buildFinalDecks() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: EmptyCardDeck(
            cardSuit: CardSuit.hearts,
            cardsAdded: finalHeartsDeck,
            onCardAdded: (cards, index) {
              finalHeartsDeck.addAll(cards);
              int? length = _getListFromIndex(index)?.length;
              _getListFromIndex(index)
                  ?.removeRange(length! - cards.length, length);
              _refreshList(index);
            },
            columnIndex: 8,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: EmptyCardDeck(
            cardSuit: CardSuit.diamonds,
            cardsAdded: finalDiamondsDeck,
            onCardAdded: (cards, index) {
              finalDiamondsDeck.addAll(cards);
              int? length = _getListFromIndex(index)?.length;
              _getListFromIndex(index)
                  ?.removeRange(length! - cards.length, length);
              _refreshList(index);
            },
            columnIndex: 9,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: EmptyCardDeck(
            cardSuit: CardSuit.spades,
            cardsAdded: finalSpadesDeck,
            onCardAdded: (cards, index) {
              finalSpadesDeck.addAll(cards);
              int? length = _getListFromIndex(index)?.length;
              _getListFromIndex(index)
                  ?.removeRange(length! - cards.length, length);
              _refreshList(index);
            },
            columnIndex: 10,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: EmptyCardDeck(
            cardSuit: CardSuit.clubs,
            cardsAdded: finalClubsDeck,
            onCardAdded: (cards, index) {
              finalClubsDeck.addAll(cards);
              int? length = _getListFromIndex(index)?.length;
              _getListFromIndex(index)
                  ?.removeRange(length! - cards.length, length);
              _refreshList(index);
            },
            columnIndex: 11,
          ),
        ),
      ],
    );
  }

  // Initialise a new game
  void _initialiseGame() {

    print(_result);

    cardColumn1 = [];
    cardColumn2 = [];
    cardColumn3 = [];
    cardColumn4 = [];
    cardColumn5 = [];
    cardColumn6 = [];
    cardColumn7 = [];

    // Stores the card deck
    cardDeckClosed = [];
    cardDeckOpened = [];

    // Stores the card in the upper boxes
    finalHeartsDeck = [];
    finalDiamondsDeck = [];
    finalSpadesDeck = [];
    finalClubsDeck = [];

    List<PlayingCard> allCards = [];

    // Add all cards to deck
    for (var suit in CardSuit.values) {
      for (var type in CardType.values) {
        allCards.add(PlayingCard(
          cardType: type,
          cardSuit: suit,
          faceUp: false,
        ));
      }
    }

    Random random = Random();

    // Add cards to columns and remaining to deck
    for (int i = 0; i < 28; i++) {
      int randomNumber = random.nextInt(allCards.length);

      if (i == 0) {
        PlayingCard card = allCards[randomNumber];
        cardColumn1.add(
          card
            ..opened = true
            ..faceUp = true,
        );
        allCards.removeAt(randomNumber);
      } else if (i > 0 && i < 3) {
        if (i == 2) {
          PlayingCard card = allCards[randomNumber];
          cardColumn2.add(
            card
              ..opened = true
              ..faceUp = true,
          );
        } else {
          cardColumn2.add(allCards[randomNumber]);
        }
        allCards.removeAt(randomNumber);
      } else if (i > 2 && i < 6) {
        if (i == 5) {
          PlayingCard card = allCards[randomNumber];
          cardColumn3.add(
            card
              ..opened = true
              ..faceUp = true,
          );
        } else {
          cardColumn3.add(allCards[randomNumber]);
        }
        allCards.removeAt(randomNumber);
      } else if (i > 5 && i < 10) {
        if (i == 9) {
          PlayingCard card = allCards[randomNumber];
          cardColumn4.add(
            card
              ..opened = true
              ..faceUp = true,
          );
        } else {
          cardColumn4.add(allCards[randomNumber]);
        }
        allCards.removeAt(randomNumber);
      } else if (i > 9 && i < 15) {
        if (i == 14) {
          PlayingCard card = allCards[randomNumber];
          cardColumn5.add(
            card
              ..opened = true
              ..faceUp = true,
          );
        } else {
          cardColumn5.add(allCards[randomNumber]);
        }
        allCards.removeAt(randomNumber);
      } else if (i > 14 && i < 21) {
        if (i == 20) {
          PlayingCard card = allCards[randomNumber];
          cardColumn6.add(
            card
              ..opened = true
              ..faceUp = true,
          );
        } else {
          cardColumn6.add(allCards[randomNumber]);
        }
        allCards.removeAt(randomNumber);
      } else {
        if (i == 27) {
          PlayingCard card = allCards[randomNumber];
          cardColumn7.add(
            card
              ..opened = true
              ..faceUp = true,
          );
        } else {
          cardColumn7.add(allCards[randomNumber]);
        }
        allCards.removeAt(randomNumber);
      }
    }

    cardDeckClosed = allCards;
    cardDeckOpened.add(
      cardDeckClosed.removeLast()
        ..opened = true
        ..faceUp = true,
    );

    setState(() {});
  }

  void _refreshList(int index) {
    if (finalDiamondsDeck.length +
            finalHeartsDeck.length +
            finalClubsDeck.length +
            finalSpadesDeck.length ==
        52) {
      winLoseFunction(true);
      //_Win();
    }
    setState(() {
      if (_getListFromIndex(index)!.isNotEmpty) {
        _getListFromIndex(index)![_getListFromIndex(index)!.length - 1]
          ..opened = true
          ..faceUp = true;
      }
    });
  }


  void winLoseFunction(bool winlose){
    if (winlose == false){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Are you sure you want to end the Game?"),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _reset();
                  _start();
                  _initialiseGame();
                  Navigator.pop(context);
                },
                child: const Text("Yes"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),
            ],
          );
        },
      );
    }else{
      _Win();
    }
  }
  //  a win condition
  void _Win() {
    print(_result);
    winLose = true;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Congratulations!"),
          content: Text("You Win! You Finished it at the time of $_result"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _reset();
                _start();
                _initialiseGame();
                Navigator.pop(context);
              },
              child: const Text("Play again"),
            ),
          ],
        );
      },
    );
  }

  void _start() {
    // Timer.periodic() will call the callback function every 100 milliseconds
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      // Update the UI
      setState(() {
        // result in hh:mm:ss format
        _result =
        '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
      });
    });
    // Start the stopwatch
    _stopwatch.start();
  }

  // This function will be called when the user presses the Stop button
  void _stop() {
    _timer.cancel();
    _stopwatch.stop();
  }

  // This function will be called when the user presses the Reset button
  void _reset() {
    _stop();
    _stopwatch.reset();

    // Update the UI
    setState(() {});
  }

  List<PlayingCard>? _getListFromIndex(int index) {
    switch (index) {
      case 0:
        return cardDeckOpened;
      case 1:
        return cardColumn1;
      case 2:
        return cardColumn2;
      case 3:
        return cardColumn3;
      case 4:
        return cardColumn4;
      case 5:
        return cardColumn5;
      case 6:
        return cardColumn6;
      case 7:
        return cardColumn7;
      case 8:
        return finalHeartsDeck;
      case 9:
        return finalDiamondsDeck;
      case 10:
        return finalSpadesDeck;
      case 11:
        return finalClubsDeck;
      default:
        return null;
    }
  }
}

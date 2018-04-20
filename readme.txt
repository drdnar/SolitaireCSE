


                                   Solitaire
                                13 November 2014



====== Introduction ============================================================

    Since Windows 3.0, Windows has included two electronic versions of two
Solitaire (or Patience in UK English) type card games.  Windows called them
Solitaire and FreeCell.  This app currently implements a clone of both programs.

    For the precise rules of Klondike and FreeCell, please consult the Internet. 



====== Usage ===================================================================

INSTALLATION, RUNNING, & UNINSTALLATION

    To install Solitaire, send the solitaire.8ck file to your TI-84 Plus C SE.
(For helping sending files to your calculator, please consult the TI Connect
documentation.)

    Once solitaire.8ck has been transferred to your calculator, it will appear
under the APPS menu.  Solitaire cannot be launched from Doors CSE.

    To remove Solitaire from your calculator, use the Memory Management menu to
delete both the app named Solitair and the appvar named Solitair.

MAIN MENU

    Solitaire's main menu lets you select which game to play, and the options
applicable for the chosen game.  The currently selected menu item is displayed in
inverted color; that is, white text on black background.  The arrow keys will
select different items.  Press ENTER or 2ND to select an item.

    To quit, you must press the quit button at the bottom of the screen.
    
    Solitaire keeps basic statistics on how often you win or forfeit each game.
Press WINDOW to see that information.

    Unlike in the OS, Solitaire will not dim the screen after a period of no
activity.  However, after three minutes, Solitaire will terminate itself and
turn the calculator off.  If this happens while a game is in progress, Solitaire
will save your game if there is sufficient free RAM (200 bytes).

GENERAL GAME PLAY

    Once you have started a game, use the arrow keys to move the cursor around.
Use ENTER or 2ND to select a card, move the cursor to another card, and then use
ENTER or 2ND again to place the card.  Cards that are hidden may be revealed
with ENTER or 2ND.  ALPHA is a short cut key that will move the card under the
cursor to a home cell (foundation), if possible.  Additionally, it will then
scan the tableau once for any other cards that can be moved.

    If you find that you cannot win the game you are currently playing, you can
forfeit the game by pressing CLEAR.  You will need to confirm that you wish to
quit.

    If you do not a press any keys for three minutes, Solitaire will attempt to
save the in-progress game and then turn off the calculator, returning you to the
home screen; see above for more information.

SAVING

    Solitaire uses an appvar named Solitair to save your settings and
statistics.  This appvar is 100 bytes in size at a minimum.  It is normally in
RAM.  However, if you archive the appvar, Solitaire will always rearchive it for
you when you quit.  This is not recommended, especially if you save a game,
because it causes excessive wear on the archive memory.

    Additionally, while you are playing a game, Solitaire can save your game and
resume it when you return to the app.  The saved game will always resume
immediately when you restart the app.

    To save an in-progress game, press MODE or XTthetan.  The difference between
them is that XTthetan will not save any undo information, which saves about 800
bytes of RAM.  Additionally, Solitaire will automatically save the game and quit
if you do not press any key for three minutes.

    If there is sufficient free RAM, the undo stack (see below) will be saved
along with the game state; the save appvar will be 970 bytes.  If there is not
enough free RAM for the undo stack, but there is at least 200 bytes of free RAM,
the game will be saved, but not the undo stack.  If you are playing a game, and
press no buttons for more than three minutes, Solitaire will attempt to save
your game (according to the above rules), and then turn the calculator off.  
Again, you can also manually force a save without the undo stack by pressing the
XTthetan key.

    There are some conditions that can prevent Solitaire's save feature from
working:
  - An appvar named Solitair was created by another application.  Solitaire
    cannot use any other appvar name.
  - There is not enough free RAM.  If there is enough free RAM for the appvar to
    save statistics, then they will be updated when you quit; however attempting
    to use the save feature (either by pressing MODE or waiting three minutes)
    will cause the app to update its statistics, but not save your game.  The
    aborted game will not be counted as a win or forfeit.
  - There is not enough RAM to unarchive the appvar when it is archived.  This
    is exactly like above, but statistics won't be saved, either, and any saved
    game cannot be resumed.
  - The appvar was created by an older version of Solitaire, and the new version
    cannot understand it.
In any of these circumstances, attempting to invoke the game saving feature---
either through pressing MODE or waiting three minutes---WILL NOT SAVE YOUR IN-
PROGRESS GAME.

    If you repeatedly get error messages when starting Solitaire and you are
sure there are not, in fact, any problems, try deleting the appvar Solitair.

UNDO FEATURE

    Solitaire features an undo feature, like the Windows games.  Press GRAPH to
undo a move.  Solitaire's undo is more powerful than the Windows one; you can go
back more than one move.  In Klondike, you can go back up to three moves.
(Klondike is a game of chance, and being able to go backward lets you look at
hidden cards, and then change your mind, which is cheating.)  In FreeCell, you
can go back up to 255 moves.  If you need move than 255 moves to complete a game
of FreeCell, you are not solving very efficiently.

    As stated above, the game saving feature will save the undo stack unless
there is not enough free RAM, or you use the XTthetan key.

BUG CHECKS

    Solitaire contains sanity checks in certain areas, in which the game
verifies that its internal data is in a valid state.  If a sanity check fails,
it means that the app has a bug.  Therefore, the game will display an error
message saying BUG CHECK, followed by some numbers.  A BUG CHECK can also be
triggered by press ON at any time, which may be useful if the game appears to
have locked up.  If you see a BUG CHECK and you did not cause it purposefully,
please record the numbers, and send them to me, with a thorough description of
what you were doing when the BUG CHECK was triggered.  If at all possible, also
send an exact list of steps that cause the issue; you may also need to include
the appvar Solitair.

    Press any key (except ON) twice to dismiss the BUG CHECK screen.  Solitaire
will always return to the homescreen after a BUG CHECK.


------ Klondike ----------------------------------------------------------------

    Klondike is the name for the specific version of Solitaire Windows is known
for.

    For screen resolution and organization reasons, the layout is different than
in most well-known versions of Klondike Solitaire.  The tableau is laid-out
across the top of the screen, and the foundations and waste are on the left.

    Y= will draw more cards from the deck.  Alternatively, you may simply click
on the deck using 2ND or ENTER.  Click on a hidden card to flip it.

    There are two main scoring modes: normal and Vegas.  In normal mode, the
score is always positive. 500 points is average for an un-timed game, 700-plus
is excellent.

    Vegas scoring has two sub-modes: non-cumulative and cumulative.  In Vegas
scoring, you only get one pass through the deck.  When you start the game, you
start 52 currency units (e.g. US dollars) in debt, and earn back 5 units for
every card moved to a home cell (or foundation).  With only pass through the
deck, your chances of winning are very small.  In fact, even earning back more
than 52 units is very hard.  In cumulative mode, you get to retain any debt (or
credit, however unlikely that may be) from previous hands.  Switching back to
normal scoring will erase your debt.  (Caution: May not work in real casinos.)

    Basically, in Vegas mode, you're almost certain to lose.  That's why it's
called Vegas mode.

    If you enable the timer, in normal scoring mode, you lose two points every
ten seconds.  When you win, you also get a time bonus, calculated as
60000 / seconds played.  This is different than Windows, which used 700000 as
the constant, so most of your points would come from the time bonus, which I
don't like.  In Vegas mode, the timer serves no purpose.


------ FreeCell ----------------------------------------------------------------

    FreeCell is a game similar to Klondike Solitaire.  However, an important
difference is that all cards are visible when you start the game.  Also, you get
four free cells that can be used as a temporary holding area for exactly one
card.  Therefore, unlike Klondike, FreeCell is purely a logic/strategy game.

    Unlike in Windows FreeCell, the four home cells (foundations) and free cells
are not on the top of the screen.  Instead, they are on the left side of the
screen; this is purely due to the low resolution of the TI-84 Plus C SE screen.
It lets the cards be bigger, and therefore more readable.  The lowest four slots
are the home cells, and the ones above are the free cells.

    This implementation of FreeCell provides the same 32000 unique games that
the original Windows FreeCell contained, the so-call Microsoft 32000.  Every
game except one is solvable with the normal four free cells; the unsolvable game
is #11982, which can be solved with a fifth free cell.  Dozens of people have
claimed to have solved all 31999; if you attempt to solve all of them before
graduating, you are unlikely to graduate.  Numbers 1941 and 10692 are also
considered very hard, and 617 often trips up beginners, or so I'm told.  You
can find solutions to all 31999 solvable games online in various places.

    This implementation of FreeCell lets you select the number of free cells.
The default is four.  If you add a fifth, even #11982 is solvable.  With a
sixth, the game should be very easy.  Perhaps surprisingly, 99% of games are
solvable with three free cells, and 80% are solvable with two.  See
http://www.solitairelaboratory.com/fcfaq.html#WinRate for more information.
(Yet, only 20% are solvable with one free cell.)

    After you win a game, a new, random game number is selected.  If you want to
know the previous game number, select QUIT on the win screen, and then press
WINDOW on the main menu screen.



====== About ===================================================================

    Discussion threads about this (as of last update) are on Omnimaga and
Cemetech at
http://www.omnimaga.org/ti-z80-calculator-projects/solitaire-klondike-and-freecell/
and http://www.cemetech.net/forum/viewtopic.php?p=217810 (respectively).
You may direct email to drdnar@gmail.com ; you should include Solitaire in the
subject line so I know what the email is about.

------ Credits -----------------------------------------------------------------

    FloppusMaximus and BrandonW are responsible for nearly all of the OS
documentation that made this possible.  KermM provided the vital insight of the
identity of the specific LCD driver the TI-84 Plus C SE uses, without which this
game could not operate at a reasonable speed.

    Xeda helpfully provided some optimizations for some routines.

    The algorithms for reproducing the Microsoft 32000 FreeCell games are
documented at http://rosettacode.org/wiki/Deal_cards_for_FreeCell .
http://www.solitairelaboratory.com/fcfaq.html clarified some of the rules of
FreeCell for me.


------ Change Log --------------------------------------------------------------

Build 1050 (13 November 2014)
 - Fixed stack overflow issue that would happen if you played more than 200ish
   games without exiting the app
 - Prevented a potential issue where unknown behavior could occur if a
   GarbageCollect or error occurred during saving
 - Fixed bug where saving a FreeCell game would not re-archive the appvar
   (Why did this happen?  The above change also fixed this for some reason.)
 - Plugging in a USB cable no longer causes an abort
 - Optimized some code for size
 - 238 free bytes remaining
 - Unless new bugs are discovered or somebody has a better idea for the face
   card graphics, this is the last update.

Build 1000 (9 May 2014)
 - Fixed supermove free cell count; now each free tableau slot doubles count as
   it should
 - Moved interrupts back into RAM to free up some space
 - If the appvar is archived when you start Solitaire, it will be archived when
   you quit.
 - Finally added face card graphics
 - 152 free bytes remaining

Build 956 (21 April 2014)
 - Optimized more
 - Added High Score text to Klondike win screen for comparison
 - Fixed bug in positioning of text in FreeCell win screen
 - Fixed YET ANOTHER bug in supermove in which you could not supermove to an
   empty tableau slot, and also made it so the empty cell wouldn't count as free
   because you're moving to it
 - About 1700 free bytes remaining

Build 922 (15 April 2014)
 - Optimized some stuff
 - Tweaked the behavior of automove
 - Added automove to controls help text
 - Added some code to support having 4-color graphics for face cards
 - Added time bonus
 - Edited readme for completeness
 - About 1600 free bytes remaining

Build 816 (10 April 2014)
 - Fixed minor bug with undo not deducting points if score was 1
 - Fixed bug in which supermove again failed to compute correct number of free
   cells due to counter not being reset.
 - Added a sort of automove in which cards will automatically be moved to a
   foundation when possible
 - Fixed FreeCell not counting all moves

Build 668 (4 April 2014)
 - Fixed an issue with Panic not reporting correct register values, making it
   less useful
 - Fixed a bug in FreeCell's supermove where it would LDIR the wrong number of
   cards.  Normally, it would copy too many, but the stack size counter would be
   updated correctly, so the extra cards were invisible.
 - Fixed a bug in FreeCell's supermove when you moved a stack to an empty cell
 - Fixed a bug where FreeCell's supermove counted foundations as free cells,
   instead of counting the free cells as free cells.  (What? The names were
   similar.)
 - Implemented undo feature for both Klondike and FreeCell.

Build 576 (1 April 2014, not a joke)
 - Fixed bug where selecting AGAIN after winning a game would prevent game
   saving from working in the new game.
 - Minor changes to the modal dialog routine
 - Fixed a bug where, after resuming game, the timer would not restart
   correctly.
 - The last release didn't have code to deal with the deep stacks possible in
   FreeCell.  This is now fixed.
 - Added some comments in various places in the code
 - Changed variables, so save compatibility is lost
 - GUI cursor now blinks
 - Fixed the YOU WIN dialog having a different score than the score under the
   KLONDIKE text.  (The YOU WIN score was always the correct one.)
 - Fixed a bug in FreeCell that would allow selection of an empty stack!  This
   would generally cause a panic on any attempt to move the un-card.
 - Made the free RAM required for game saving substantially smaller.
 - Fixed a bug in clean-up termination code that could cause a crash in CLASSIC
 - Implemented FreeCell supermove
 - Fixed bug where if a card is selected when a game is saved, the selection
   isn't rehighlighted when the game is resumed.  (The fix is to remove the
   selection.)

Build 463 (27 March 2014)
 - Added Random! button to GUI
 - Fixed glitch in Klondike where disabling the timer would also make the Draw
   text disappear
 - Added some basic statistics
 - Optimized some code
 - Added win detection logic
 - Added dialogs
 - Added FreeCell game mode
 - Fixed a bug in Klondike where moving a card onto a foundation would leave the
   card below the new top card still selected, so you could move both the top 
   card and card underneath onto another pile
 - Fixed points being deducted at the wrong time when turning over the waste
 - Fixed points being deducted after waste is empty
 - Added settings, stats, and game saving.  Now APDs correctly save your gave (if
   possible)!
 - Made FreeCell number entry and free cell count entry a little better
 - Changed a bunch of code relating to the card cursor positioning that I had been
   putting off until I implemented FreeCell

Build 259 (19 March 2014)
 - ALPHA now implements move-to-home-cell
 - If you empty the waste, it shows the card beneath if one is there
 - Deck graphic changes to empty box if no more cards are in deck
 - Down key moves to bottom-most card in stack
 - Changed how the arrow keys move between stacks
 - All illegal moves should now also unselect the currently selected card
    - So ALPHA will unselect the currently selected card
 - HOPEFULLY fixed rare random freeze issue
 - Implemented timer
 - Implemented scoring
 - APD now three minutes
 - Every invocation of the build.bat file will now increment the build number,
   so every version has a unique ID.

Initial release (12 March 2014)
 - Basic functionality
 - Playable Klondike Solitaire demo
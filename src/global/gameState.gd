extends Node

enum Idea { RAINBOW, AIR, BREAD, ROCK, XXX, YYY, ZZZ }

var maxAmountOfIdeas = 20
var ideaPool: Array[Idea] = [Idea.RAINBOW, Idea.AIR, Idea.BREAD, Idea.ROCK];

func addNewIdea(newIdea: Idea):
	if not newIdea in ideaPool:
		ideaPool.append(newIdea);
		UIManager.updatePoolItem.emit(ideaPool.size() - 1)

func getIdeaFromPool(index: int):
	if index < ideaPool.size() and (ideaPool[index] != null):
		return ideaPool[index];
	else:
		return null;

func testPool1():
	addNewIdea(Idea.XXX);

func testPool2():
	addNewIdea(Idea.YYY);

func testPool3():
	addNewIdea(Idea.ZZZ);

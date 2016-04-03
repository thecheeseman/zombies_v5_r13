main()
{
	self setModel("xmodel/playerbody_british_airborne_clean");
	character\_utility::attachFromArray(xmodelalias\head_allied::main());
	self.voice = "american";
}

precache()
{
	precacheModel("xmodel/playerbody_british_airborne_clean");
	character\_utility::precacheModelArray(xmodelalias\head_allied::main());
}

main()
{
	self setModel("xmodel/playerbody_british_commando_winter");
	character\_utility::attachFromArray(xmodelalias\head_allied::main());
	self setViewmodel("xmodel/viewmodel_hands_british");
	self.voice = "american";
}

precache()
{
	precacheModel("xmodel/playerbody_british_commando_winter");
	character\_utility::precacheModelArray(xmodelalias\head_allied::main());
	precacheModel("xmodel/viewmodel_hands_british");
}

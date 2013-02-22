# Chapter 1

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis vulputate nisi non mi adipiscing vulputate. Donec egestas interdum blandit. Phasellus lectus massa, varius vel varius in, congue a lacus. Nunc mauris purus, pulvinar vel blandit non, vestibulum in ante. Sed molestie, leo ac facilisis ornare, odio nulla accumsan purus, vitae adipiscing velit elit vitae nisl. Pellentesque odio nisi, malesuada in suscipit sit amet, lacinia ut tellus. Pellentesque feugiat enim a justo tempor ultricies.

Donec a auctor enim. Ut tellus est, tempus vel lacinia ut, imperdiet a ligula. Nunc mi justo, suscipit quis imperdiet ut, dictum sit amet magna. Maecenas interdum blandit bibendum. Suspendisse eget orci eget ligula imperdiet malesuada. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Curabitur vel tortor sit amet nisi pretium vehicula ut sit amet mauris. Aliquam at turpis nisi. Cras nec purus neque. Duis nisl purus, eleifend sed placerat non, mattis id est. Sed vel urna risus. Vestibulum ullamcorper massa at lacus bibendum ultricies. Duis sed vehicula sapien. Donec pellentesque varius faucibus. Integer pharetra cursus enim facilisis facilisis.

## Doing it right

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis vulputate nisi non mi adipiscing vulputate. Donec egestas interdum blandit. Phasellus lectus massa, varius vel varius in, congue a lacus. Nunc mauris purus, pulvinar vel blandit non, vestibulum in ante. Sed molestie, leo ac facilisis ornare, odio nulla accumsan purus, vitae adipiscing velit elit vitae nisl. Pellentesque odio nisi, malesuada in suscipit sit amet, lacinia ut tellus. Pellentesque feugiat enim a justo tempor ultricies.

```
// Listing 1
void P_MovePlayer (player_t* player) {
  ticcmd_t* cmd;
  cmd = &player->cmd;

  // Turn the player
  player->mo->angle += (cmd->angleturn<<16);

  // Do not let the player control movement
  // if not onground.
  onground = (player->mo->z <= player->mo->floorz);

  // Move the player forward, if allowed
  if (cmd->forwardmove && onground)
    P_Thrust (player, player->mo->angle, cmd->forwardmove*2048);

  // Move the player sideways, if allowed
  if (cmd->sidemove && onground)
    P_Thrust (player, player->mo->angle-ANG90, cmd->sidemove*2048);
}
```

Donec a auctor enim. Ut tellus *est*, tempus vel *lacinia ut*, **imperdiet a ligula**. Nunc mi justo, suscipit quis imperdiet ut, dictum sit amet magna. Maecenas interdum blandit bibendum. Suspendisse eget orci eget ligula imperdiet malesuada. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Curabitur vel tortor sit amet nisi pretium vehicula ut sit amet mauris. Aliquam at turpis nisi. Cras nec purus neque. Duis nisl purus, eleifend sed placerat non, mattis id est. Sed vel urna risus. Vestibulum ullamcorper massa at lacus bibendum ultricies. Duis sed vehicula sapien. Donec pellentesque varius faucibus. Integer pharetra cursus enim facilisis facilisis.

![Hello world](images/corgi.png)

Aenean a eros quis nunc tincidunt suscipit. In hac habitasse platea dictumst. Suspendisse eget leo ac libero hendrerit aliquet. Aenean ornare, nunc in suscipit eleifend, tortor lorem facilisis turpis, eget pulvinar nulla arcu vitae lorem. Curabitur sed ipsum neque, viverra pellentesque dolor. Nam vulputate ullamcorper est, sit amet sodales metus commodo non. Nullam in lacus mauris, eget venenatis leo. Nulla auctor nulla vitae magna accumsan faucibus. Aenean at vulputate turpis. Vivamus luctus fermentum pulvinar. Etiam luctus sollicitudin eros non sollicitudin. Phasellus nec ante eu lacus egestas dapibus. Morbi in lectus nec lectus ullamcorper euismod a quis dui. Nulla auctor viverra tortor, sit amet molestie lacus iaculis porttitor. Vivamus scelerisque augue eget mauris lacinia porta. Aliquam erat volutpat.

Cras luctus nisi a mi tincidunt fringilla. Pellentesque molestie felis ut tortor scelerisque condimentum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin commodo magna et purus suscipit sit amet congue sapien tincidunt. Suspendisse potenti. Nunc fringilla ligula lorem, in euismod felis. Suspendisse consequat pharetra placerat. Vivamus vel lectus sit amet nibh consectetur sodales eu fringilla eros. Mauris volutpat elementum rhoncus.

Nulla vitae malesuada leo. Aliquam ullamcorper diam sed erat euismod vitae ornare enim elementum. Maecenas dapibus fermentum rutrum. Nunc eu convallis nisi. Proin nisi lorem, porttitor a eleifend sit amet, lobortis eu neque. Vivamus diam mauris, blandit vitae commodo vitae, blandit sed nisi. Quisque sed gravida nulla. Aliquam erat volutpat. Donec non auctor erat. Mauris pellentesque ipsum et sapien molestie imperdiet. Integer ac molestie turpis. Praesent commodo augue nec eros sodales ut mollis sem facilisis. Duis a accumsan elit. Sed sodales iaculis justo, et tristique odio malesuada sed.

## Second section

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis vulputate nisi non mi adipiscing vulputate. Donec egestas interdum blandit. Phasellus lectus massa, varius vel varius in, congue a lacus. Nunc mauris purus, pulvinar vel blandit non, vestibulum in ante. Sed molestie, leo ac facilisis ornare, odio nulla accumsan purus, vitae adipiscing velit elit vitae nisl. Pellentesque odio nisi, malesuada in suscipit sit amet, lacinia ut tellus. Pellentesque feugiat enim a justo tempor ultricies.

Donec a auctor enim. Ut tellus est, tempus vel lacinia ut, imperdiet a ligula. Nunc mi justo, suscipit quis imperdiet ut, dictum sit amet magna. Maecenas interdum blandit bibendum. Suspendisse eget orci eget ligula imperdiet malesuada. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Curabitur vel tortor sit amet nisi pretium vehicula ut sit amet mauris. Aliquam at turpis nisi. Cras nec purus neque. Duis nisl purus, eleifend sed placerat non, mattis id est. Sed vel urna risus. Vestibulum ullamcorper massa at lacus bibendum ultricies. Duis sed vehicula sapien. Donec pellentesque varius faucibus. Integer pharetra cursus enim facilisis facilisis.

Aenean a eros quis nunc tincidunt suscipit. In hac habitasse platea dictumst. Suspendisse eget leo ac libero hendrerit aliquet. Aenean ornare, nunc in suscipit eleifend, tortor lorem facilisis turpis, eget pulvinar nulla arcu vitae lorem. Curabitur sed ipsum neque, viverra pellentesque dolor. Nam vulputate ullamcorper est, sit amet sodales metus commodo non. Nullam in lacus mauris, eget venenatis leo. Nulla auctor nulla vitae magna accumsan faucibus. Aenean at vulputate turpis. Vivamus luctus fermentum pulvinar. Etiam luctus sollicitudin eros non sollicitudin. Phasellus nec ante eu lacus egestas dapibus. Morbi in lectus nec lectus ullamcorper euismod a quis dui. Nulla auctor viverra tortor, sit amet molestie lacus iaculis porttitor. Vivamus scelerisque augue eget mauris lacinia porta. Aliquam erat volutpat.

Cras luctus nisi a mi tincidunt fringilla. Pellentesque molestie felis ut tortor scelerisque condimentum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin commodo magna et purus suscipit sit amet congue sapien tincidunt. Suspendisse potenti. Nunc fringilla ligula lorem, in euismod felis. Suspendisse consequat pharetra placerat. Vivamus vel lectus sit amet nibh consectetur sodales eu fringilla eros. Mauris volutpat elementum rhoncus.

Nulla vitae malesuada leo. Aliquam ullamcorper diam sed erat euismod vitae ornare enim elementum. Maecenas dapibus fermentum rutrum. Nunc eu convallis nisi. Proin nisi lorem, porttitor a eleifend sit amet, lobortis eu neque. Vivamus diam mauris, blandit vitae commodo vitae, blandit sed nisi. Quisque sed gravida nulla. Aliquam erat volutpat. Donec non auctor erat. Mauris pellentesque ipsum et sapien molestie imperdiet. Integer ac molestie turpis. Praesent commodo augue nec eros sodales ut mollis sem facilisis. Duis a accumsan elit. Sed sodales iaculis justo, et tristique odio malesuada sed.

> Foo bar -- wilkie

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis vulputate nisi non mi adipiscing vulputate. Donec egestas interdum blandit. Phasellus lectus massa, varius vel varius in, congue a lacus. Nunc mauris purus, pulvinar vel blandit non, vestibulum in ante. Sed molestie, leo ac facilisis ornare, odio nulla accumsan purus, vitae adipiscing velit elit vitae nisl. Pellentesque odio nisi, malesuada in suscipit sit amet, lacinia ut tellus. Pellentesque feugiat enim a justo tempor ultricies.

Donec a auctor enim. Ut tellus est, tempus vel lacinia ut, imperdiet a ligula. Nunc mi justo, suscipit quis imperdiet ut, dictum sit amet magna. Maecenas interdum blandit bibendum. Suspendisse eget orci eget ligula imperdiet malesuada. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Curabitur vel tortor sit amet nisi pretium vehicula ut sit amet mauris. Aliquam at turpis nisi. Cras nec purus neque. Duis nisl purus, eleifend sed placerat non, mattis id est. Sed vel urna risus. Vestibulum ullamcorper massa at lacus bibendum ultricies. Duis sed vehicula sapien. Donec pellentesque varius faucibus. Integer pharetra cursus enim facilisis facilisis.

Aenean a eros quis nunc tincidunt suscipit. In hac habitasse platea dictumst. Suspendisse eget leo ac libero hendrerit aliquet. Aenean ornare, nunc in suscipit eleifend, tortor lorem facilisis turpis, eget pulvinar nulla arcu vitae lorem. Curabitur sed ipsum neque, viverra pellentesque dolor. Nam vulputate ullamcorper est, sit amet sodales metus commodo non. Nullam in lacus mauris, eget venenatis leo. Nulla auctor nulla vitae magna accumsan faucibus. Aenean at vulputate turpis. Vivamus luctus fermentum pulvinar. Etiam luctus sollicitudin eros non sollicitudin. Phasellus nec ante eu lacus egestas dapibus. Morbi in lectus nec lectus ullamcorper euismod a quis dui. Nulla auctor viverra tortor, sit amet molestie lacus iaculis porttitor. Vivamus scelerisque augue eget mauris lacinia porta. Aliquam erat volutpat.

Cras luctus nisi a mi tincidunt fringilla. Pellentesque molestie felis ut tortor scelerisque condimentum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin commodo magna et purus suscipit sit amet congue sapien tincidunt. Suspendisse potenti. Nunc fringilla ligula lorem, in euismod felis. Suspendisse consequat pharetra placerat. Vivamus vel lectus sit amet nibh consectetur sodales eu fringilla eros. Mauris volutpat elementum rhoncus.

Nulla vitae malesuada leo. Aliquam ullamcorper diam sed erat euismod vitae ornare enim elementum. Maecenas dapibus fermentum rutrum. Nunc eu convallis nisi. Proin nisi lorem, porttitor a eleifend sit amet, lobortis eu neque. Vivamus diam mauris, blandit vitae commodo vitae, blandit sed nisi. Quisque sed gravida nulla. Aliquam erat volutpat. Donec non auctor erat. Mauris pellentesque ipsum et sapien molestie imperdiet. Integer ac molestie turpis. Praesent commodo augue nec eros sodales ut mollis sem facilisis. Duis a accumsan elit. Sed sodales iaculis justo, et tristique odio malesuada sed.

!note This is a noted section.

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis vulputate nisi non mi adipiscing vulputate. Donec egestas interdum blandit. Phasellus lectus massa, varius vel varius in, congue a lacus. Nunc mauris purus, pulvinar vel blandit non, vestibulum in ante. Sed molestie, leo ac facilisis ornare, odio nulla accumsan purus, vitae adipiscing velit elit vitae nisl. Pellentesque odio nisi, malesuada in suscipit sit amet, lacinia ut tellus. Pellentesque feugiat enim a justo tempor ultricies.

Donec a auctor enim. Ut tellus est, tempus vel lacinia ut, imperdiet a ligula. Nunc mi justo, suscipit quis imperdiet ut, dictum sit amet magna. Maecenas interdum blandit bibendum. Suspendisse eget orci eget ligula imperdiet malesuada. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Curabitur vel tortor sit amet nisi pretium vehicula ut sit amet mauris. Aliquam at turpis nisi. Cras nec purus neque. Duis nisl purus, eleifend sed placerat non, mattis id est. Sed vel urna risus. Vestibulum ullamcorper massa at lacus bibendum ultricies. Duis sed vehicula sapien. Donec pellentesque varius faucibus. Integer pharetra cursus enim facilisis facilisis.

Aenean a eros quis nunc tincidunt suscipit. In hac habitasse platea dictumst. Suspendisse eget leo ac libero hendrerit aliquet. Aenean ornare, nunc in suscipit eleifend, tortor lorem facilisis turpis, eget pulvinar nulla arcu vitae lorem. Curabitur sed ipsum neque, viverra pellentesque dolor. Nam vulputate ullamcorper est, sit amet sodales metus commodo non. Nullam in lacus mauris, eget venenatis leo. Nulla auctor nulla vitae magna accumsan faucibus. Aenean at vulputate turpis. Vivamus luctus fermentum pulvinar. Etiam luctus sollicitudin eros non sollicitudin. Phasellus nec ante eu lacus egestas dapibus. Morbi in lectus nec lectus ullamcorper euismod a quis dui. Nulla auctor viverra tortor, sit amet molestie lacus iaculis porttitor. Vivamus scelerisque augue eget mauris lacinia porta. Aliquam erat volutpat.

Cras luctus nisi a mi tincidunt fringilla. Pellentesque molestie felis ut tortor scelerisque condimentum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin commodo magna et purus suscipit sit amet congue sapien tincidunt. Suspendisse potenti. Nunc fringilla ligula lorem, in euismod felis. Suspendisse consequat pharetra placerat. Vivamus vel lectus sit amet nibh consectetur sodales eu fringilla eros. Mauris volutpat elementum rhoncus.

Nulla vitae malesuada leo. Aliquam ullamcorper diam sed erat euismod vitae ornare enim elementum. Maecenas dapibus fermentum rutrum. Nunc eu convallis nisi. Proin nisi lorem, porttitor a eleifend sit amet, lobortis eu neque. Vivamus diam mauris, blandit vitae commodo vitae, blandit sed nisi. Quisque sed gravida nulla. Aliquam erat volutpat. Donec non auctor erat. Mauris pellentesque ipsum et sapien molestie imperdiet. Integer ac molestie turpis. Praesent commodo augue nec eros sodales ut mollis sem facilisis. Duis a accumsan elit. Sed sodales iaculis justo, et tristique odio malesuada sed.

# Parsed Event Args --- Parameters

### Base Parameters
| `args.`*index* | Description |
| ---:|:--- |
| `timestamp` | Uses the function [time()](http://wow.gamepedia.com/API_time) to reference the time of the event when the client received it from the server. |
| `event` | The full name of the event. This is only useful when looking for a specific event or determining if a special event was triggered. |
| `hideCaster` | This parameter lets you know when there is no adequate source name for the event. The parameter `sourceName` will generally be a nil value. <br><br> __NOTE:__ This parser will recolor Environmental events with relevant names and spell IDs. So if this is set, you **_still_** may want to show the `sourceName`. I am considering turning this off for environmental events. |
| `sourceGUID` | The [GUID](http://wow.gamepedia.com/GUID) of the source.
| `sourceName` | The localized name of the source. If `hideCaster` is set, this value may be `nil`, unless the event is environmental. |
| `sourceFlags` | The [unit flags](http://wow.gamepedia.com/UnitFlag) of the source. See [Combat Object Methods](#NEED-LINK) for a set of parsing functions. May be `nil` if you try parsing it yourself. |
| `sourceRaidFlags` | The [raid flags](http://wow.gamepedia.com/RaidFlag) of the source. See [Raid Target Methods](#NEED-LINK) for a set of parsing functions. |
| `destGUID` | The [GUID](http://wow.gamepedia.com/GUID) of the destination.
| `destName` | The localized name of the destination. |
| `destFlags` | The [unit flags](http://wow.gamepedia.com/UnitFlag) of the destination. See [Combat Object Methods](#NEED-LINK) for a set of parsing functions. |
| `destRaidFlags` | The [raid flags](http://wow.gamepedia.com/RaidFlag) of the destination. See [Raid Target Methods](#NEED-LINK) for a set of parsing functions. |


### Event Prefixes

Events with the following prefixes will also have some additional parameters

| `args.prefix` | Parameters | | |
|:--- |:---:|:---:|:---:|
| `"SWING"` | *none* | | |
| `"RANGE"` | `spellId` | `spellName` | [`spellSchool`](http://wow.gamepedia.com/COMBAT_LOG_EVENT#Spell_School) |
| `"SPELL"` | `spellId` | `spellName` | [`spellSchool`](http://wow.gamepedia.com/COMBAT_LOG_EVENT#Spell_School) |
| `"SPELL_PERIODIC"` | `spellId` | `spellName` | [`spellSchool`](http://wow.gamepedia.com/COMBAT_LOG_EVENT#Spell_School) |
| `"SPELL_BUILDING"` | `spellId` | `spellName` | [`spellSchool`](http://wow.gamepedia.com/COMBAT_LOG_EVENT#Spell_School) |
| `"ENVIRONMENTAL"` | [`environmentalType`](http://wow.gamepedia.com/COMBAT_LOG_EVENT#Environmental_Type) | | |

__NOTE:__ The use of `spellSchool` above is specific to the spell that was cast. For example, if you cast a _Holy_ spell that did Arcane + Holy (_Divine_) damage, then `spellSchool` would be _Holy_ and `school` would be _Divine_.


### Event Suffixes
Use `args.suffix == "_????"` to view which additional parameters each suffix has.

#### `_DAMAGE`--- Additional Parameters

This is arguably one of the most complicated suffixes and will have its own section dealing with it.

| `args.`*index* | Description |
| ---:|:--- |
| `amount` | The _final_ amount of damage that the destination took from the source in the event. |
| `overkill` | If the destination was killed by the source, this will specify the negative health of the destination. This will be `nil` most of the time. |
| `school` | Specifies the [spell school](http://wow.gamepedia.com/COMBAT_LOG_EVENT#Spell_School) that was used to damage the destination. It is most useful for coloring the damage amount. |
| `resisted` | Shows how much damage was subtracted from `amount` that was resisted by the destination. You can use `_G["RESIST"]` for a localized string. |
| `blocked` | Shows how much damage was subtracted from `amount` that was blocked by the destination. You can use `_G["BLOCK"]` for a localized string. |
| `absorbed` | Shows how much damage was subtracted from `amount` that was absorbed by the destination. You can use `_G["ABSORB"]` for a localized string. |
| `critical` | A true/false flag that informs if the event was a critical strike. |
| `glancing` | A true/false flag that informs if the event was a glancing blow. |
| `crushing` | A true/false flag that informs if the event was a crushing blow. |
| `isOffHand` | A true/false flag that informs if the event was from the source's off-hand. |

#### `_MISSED`--- Additional Parameters

| `args.`*index* | Description |
| ---:|:--- |
| `missType` | The [type of miss](http://wow.gamepedia.com/COMBAT_LOG_EVENT#Miss_type) that occured. |
| `isOffHand` | A true/false flag that informs if the event was from the source's off-hand. |
| `amountMissed` | The potential damage that no one will ever see or care about. |
> Written with [StackEdit](https://stackedit.io/).

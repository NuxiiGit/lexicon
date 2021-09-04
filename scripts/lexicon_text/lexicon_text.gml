/// @func lexicon_text
/// @param text
/// @param [substring]
/// @param [...]
function lexicon_text(_text) {
			gml_pragma("forceinline");

			// Auto GC
			if (LEXICON_USE_CACHE && LEXICON_AUTO_GC_CACHE) __lexicon_handle_cache();
			//if (_replchr == undefined) _replchr = "";
			// We'll check to see if it already exists in the cache before processing the string at hand.
			with(LEXICON_STRUCT) {

			// Failsafe before everything else!

			var _replchr = lang_replace_chr;
			// Correct for any potential errors
			if (lang_map[$ lang_type] == undefined) {
				return lang_type + "." + _text;
			}

			// Check to see if text exists
			var _str = lang_map[$ lang_type][$ "text"][$ _text];
			if (_str == undefined) {
				return _text;
			}

			#region Cache
			// Check against Cache
			if (LEXICON_USE_CACHE) {
				if (argument_count-1 >= LEXICON_CACHE_THRESHOLD) {
					var _cacheStr = sha1_string_unicode(lang_type+"."+_text);
					if (LEXICON_USE_ADVANCE_CACHE) {
						// Normable substring replacement loop
						var _count = string_count(_replchr,_str);
						var _args = array_create(_count);
						for(var _i = 1; _i < _count; ++_i) {
							if (_i > argument_count) break;
							_args[_i-1] = argument[_i-1];
						}
							_cacheStr += sha1_string_unicode(string(_args));
					}

					if ds_map_exists(lang_cache, _cacheStr) {
						var _struct = lang_cache[? _cacheStr];
						if _struct.cacheStr == _cacheStr {
							// Update timestamp
							/*if (_struct.str != _struct.memStr) {
								if (_struct.cacheStr != _cacheStr) {
									// Recache
									var _newStruct = new _lexiconCacheText(_str, _cacheStr);
									delete _struct;
									ds_map_delete(_cacheStr
								}
							}*/
							_struct.timeStamp = current_time;
							return _struct.str;
						}
					}
				}
			}
			#endregion

			if (argument_count > 1) {
					var _count = string_count(_replchr,_str);
					for(var _i = 0; _i < _count; ++_i) {
						if (_i > argument_count-2) break;
						var _arg = argument[_i+1];
						_str = string_replace(_str, _replchr, _arg);
					}

					if (LEXICON_USE_CACHE) && (argument_count-1 >= LEXICON_CACHE_THRESHOLD) {
						var _struct = new __lexicon_cache_text(_str, _cacheStr);
						LEXICON_STRUCT.lang_cache[? _cacheStr] = _struct;
						ds_list_add(LEXICON_STRUCT.lang_cache_list, {cacheStr: _cacheStr, ref: weak_ref_create(_struct)});
						//return _struct;
					}
				}
			}

			return _str;
}
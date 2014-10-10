<?
/* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this file,
* You can obtain one at http://mozilla.org/MPL/2.0/. */

class Text
{
  /*
   * @assert ('apple', 0) == 'no apples'
   * @assert ('apple', 1) == '1 apple'
   * @assert ('apple', 2) == '2 apples'
   *
   */
	function plural($s, $count)
	{
		assert(is_numeric($count));
		
		$ret = $count==0?'no':$count;
		$ret .= ' ' . $s;
		if ($count!=1)
			$ret .= 's';
		return $ret;
	}

	function formatDateTime($datetime)
	{
		assert(is_numeric($datetime));
		
		return strftime('%d-%b-%Y %H:%M', $datetime);
	}

}
?>
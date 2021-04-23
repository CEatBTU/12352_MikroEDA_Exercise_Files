library IEEE;
use IEEE.std_logic_1164.all; -- import std_logic types
--use IEEE.std_logic_arith.all; -- import add/sub of std_logic_vector
--use IEEE.std_logic_unsigned.all;
--use IEEE.std_logic_signed.all;
use IEEE.math_real.all; 
use IEEE.numeric_std.all; -- for type conversion to_unsigned

--library STD;
--use STD.textio.all;

--------------------------------------------------------------------------------
--!@file: TB_mult_algorithmic.vhd
--!@brief: testbench for the algorithmic multiplier description
--!...
--
--!@author: Tobias Koal(TK)
--!@revision info :
-- last modification by tkoal(TK)
-- Mon Apr 13 14:27:02 CEST 2015
--------------------------------------------------------------------------------

-- entity description

entity TB_mult_algorithmic is
end entity;

-- architecture description

architecture testbench of TB_mult_algorithmic is


	-- CONSTANTS (upper case only!)


	-- SIGNALS (lower case only!)

begin

	-- this is your algorithmic multiplier description
	tb_component : entity work. mult_algorithmic(algorithmic_description)
	port map (
	);

	-- create a stimulus process here!


	-- create a golden device here!


	-- create a compare process here!




end testbench;


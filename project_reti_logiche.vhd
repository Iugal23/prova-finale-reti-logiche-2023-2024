library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project_reti_logiche is
port (
i_clk : in std_logic;
i_rst : in std_logic;
i_start : in std_logic;
i_add : in std_logic_vector(15 downto 0);
i_k : in std_logic_vector(9 downto 0);
o_done : out std_logic;
o_mem_addr : out std_logic_vector(15 downto 0);
i_mem_data : in std_logic_vector(7 downto 0);
o_mem_data : out std_logic_vector(7 downto 0);
o_mem_we : out std_logic;
o_mem_en : out std_logic
);
end project_reti_logiche;

architecture project_reti_logiche_arch of project_reti_logiche is

component contatore is
port(
i_clk: in std_logic;
i_rst: in std_logic;
i_ec: in std_logic;
i_k: in std_logic_vector (9 downto 0);
o_j: out std_logic_vector(10 downto 0)
);
end component;

component fsm is
port(
i_start: in std_logic;
i_clk: in std_logic;
i_rst: in std_logic;
i_add: in std_logic_vector (15 downto 0);
i_k: in std_logic_vector (9 downto 0);
i_j: in std_logic_vector (10 downto 0);
i_mem_data: in std_logic_vector (7 downto 0);

o_done: out std_logic;
o_mem_we: out std_logic;
o_mem_en: out std_logic;
o_ec: out std_logic;
o_mem_add: out std_logic_vector (15 downto 0);
o_mem_data: out std_logic_vector (7 downto 0)
);
end component;

signal ec : std_logic;
signal j : std_logic_vector (10 downto 0);

begin

    cnt : contatore port map(
       i_clk => i_clk,
       i_rst => i_rst,
       i_ec => ec,
       i_k => i_k,
       o_j=>j
    );
    
    fsm_map: fsm port map(
        i_start => i_start,
        i_clk => i_clk,
        i_rst => i_rst,
        i_add => i_add,
        i_k => i_k,
        i_j => j,
        i_mem_data => i_mem_data,
        
        o_done => o_done,
        o_mem_we => o_mem_we,
        o_mem_en => o_mem_en,
        o_ec => ec,
        o_mem_add => o_mem_addr,
        o_mem_data => o_mem_data
    );

end;

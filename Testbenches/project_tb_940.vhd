-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 555;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (86,0,200,0,21,0,32,0,0,0,165,0,255,0,95,0,26,0,21,0,158,0,68,0,182,0,0,0,206,0,78,0,0,0,217,0,110,0,178,0,226,0,228,0,169,0,241,0,0,0,82,0,0,0,0,0,0,0,114,0,0,0,23,0,146,0,38,0,67,0,141,0,80,0,160,0,251,0,158,0,0,0,76,0,118,0,0,0,215,0,38,0,0,0,56,0,1,0,44,0,127,0,0,0,0,0,25,0,241,0,59,0,64,0,107,0,100,0,60,0,19,0,227,0,0,0,245,0,58,0,181,0,138,0,255,0,99,0,197,0,112,0,0,0,203,0,219,0,115,0,115,0,56,0,60,0,83,0,159,0,0,0,67,0,50,0,0,0,254,0,170,0,197,0,156,0,235,0,114,0,216,0,125,0,75,0,13,0,232,0,128,0,139,0,155,0,17,0,181,0,245,0,253,0,0,0,0,0,166,0,110,0,41,0,106,0,44,0,158,0,48,0,0,0,30,0,95,0,17,0,70,0,73,0,99,0,119,0,0,0,61,0,251,0,68,0,138,0,0,0,0,0,244,0,141,0,249,0,55,0,0,0,0,0,11,0,0,0,177,0,0,0,3,0,0,0,118,0,0,0,195,0,115,0,41,0,225,0,115,0,28,0,180,0,5,0,25,0,0,0,163,0,182,0,121,0,220,0,12,0,77,0,0,0,134,0,0,0,178,0,239,0,171,0,127,0,99,0,226,0,16,0,118,0,0,0,0,0,56,0,210,0,145,0,0,0,51,0,97,0,0,0,64,0,19,0,122,0,219,0,0,0,68,0,79,0,0,0,139,0,100,0,111,0,93,0,0,0,147,0,218,0,80,0,86,0,0,0,153,0,171,0,220,0,152,0,11,0,135,0,128,0,198,0,152,0,246,0,133,0,0,0,52,0,56,0,0,0,240,0,115,0,165,0,148,0,152,0,71,0,0,0,58,0,78,0,154,0,185,0,97,0,158,0,0,0,181,0,0,0,0,0,98,0,146,0,102,0,0,0,30,0,51,0,0,0,80,0,0,0,115,0,83,0,117,0,0,0,132,0,164,0,10,0,179,0,0,0,127,0,72,0,202,0,0,0,226,0,90,0,0,0,83,0,174,0,0,0,10,0,0,0,164,0,86,0,40,0,195,0,42,0,101,0,230,0,101,0,226,0,58,0,245,0,138,0,157,0,148,0,108,0,6,0,83,0,0,0,192,0,213,0,95,0,175,0,46,0,95,0,161,0,66,0,177,0,59,0,0,0,0,0,103,0,0,0,156,0,113,0,0,0,73,0,197,0,230,0,0,0,163,0,0,0,132,0,0,0,132,0,85,0,17,0,118,0,67,0,0,0,0,0,24,0,49,0,231,0,236,0,176,0,171,0,54,0,183,0,0,0,0,0,37,0,154,0,133,0,128,0,53,0,0,0,223,0,70,0,217,0,229,0,20,0,136,0,0,0,0,0,165,0,45,0,17,0,0,0,109,0,215,0,61,0,21,0,193,0,197,0,119,0,8,0,17,0,172,0,106,0,0,0,179,0,73,0,99,0,13,0,30,0,0,0,32,0,133,0,0,0,139,0,117,0,237,0,0,0,29,0,153,0,96,0,13,0,119,0,232,0,14,0,0,0,9,0,185,0,78,0,237,0,235,0,89,0,182,0,0,0,48,0,0,0,0,0,148,0,62,0,96,0,50,0,81,0,57,0,49,0,254,0,117,0,113,0,141,0,143,0,110,0,94,0,3,0,0,0,234,0,200,0,18,0,0,0,34,0,0,0,214,0,41,0,183,0,191,0,99,0,117,0,0,0,134,0,65,0,0,0,135,0,167,0,118,0,61,0,10,0,0,0,234,0,144,0,244,0,204,0,244,0,226,0,34,0,8,0,143,0,237,0,186,0,113,0,129,0,10,0,155,0,55,0,108,0,124,0,212,0,98,0,79,0,102,0,255,0,0,0,21,0,66,0,0,0,0,0,209,0,90,0,184,0,0,0,166,0,26,0,203,0,159,0,0,0,110,0,48,0,111,0,0,0,68,0,183,0,230,0,0,0,225,0,67,0,85,0,45,0,8,0,169,0,145,0,86,0,198,0,0,0,0,0,79,0,193,0,68,0,0,0,44,0,120,0,122,0,0,0,249,0,254,0,231,0,179,0,183,0,0,0,0,0,47,0,0,0,142,0,196,0,30,0,223,0,0,0,229,0,0,0,0,0,233,0,33,0,217,0,0,0,72,0,0,0,36,0,141,0,124,0,0,0,60,0,84,0,4,0,55,0,252,0,69,0,0,0,81,0,145,0,27,0,73,0,132,0,24,0,246,0,56,0,22,0,113,0,0,0,119,0,212,0,0,0,103,0,129,0,39,0,39,0,151,0,226,0,193,0,191,0,0,0,222,0,94,0,0,0,0,0,0,0,104,0,182,0,0,0,22,0,17,0,85,0,43,0,4,0,49,0,212,0,0,0,112,0,42,0);
signal scenario_full  : scenario_type := (86,31,200,31,21,31,32,31,32,30,165,31,255,31,95,31,26,31,21,31,158,31,68,31,182,31,182,30,206,31,78,31,78,30,217,31,110,31,178,31,226,31,228,31,169,31,241,31,241,30,82,31,82,30,82,29,82,28,114,31,114,30,23,31,146,31,38,31,67,31,141,31,80,31,160,31,251,31,158,31,158,30,76,31,118,31,118,30,215,31,38,31,38,30,56,31,1,31,44,31,127,31,127,30,127,29,25,31,241,31,59,31,64,31,107,31,100,31,60,31,19,31,227,31,227,30,245,31,58,31,181,31,138,31,255,31,99,31,197,31,112,31,112,30,203,31,219,31,115,31,115,31,56,31,60,31,83,31,159,31,159,30,67,31,50,31,50,30,254,31,170,31,197,31,156,31,235,31,114,31,216,31,125,31,75,31,13,31,232,31,128,31,139,31,155,31,17,31,181,31,245,31,253,31,253,30,253,29,166,31,110,31,41,31,106,31,44,31,158,31,48,31,48,30,30,31,95,31,17,31,70,31,73,31,99,31,119,31,119,30,61,31,251,31,68,31,138,31,138,30,138,29,244,31,141,31,249,31,55,31,55,30,55,29,11,31,11,30,177,31,177,30,3,31,3,30,118,31,118,30,195,31,115,31,41,31,225,31,115,31,28,31,180,31,5,31,25,31,25,30,163,31,182,31,121,31,220,31,12,31,77,31,77,30,134,31,134,30,178,31,239,31,171,31,127,31,99,31,226,31,16,31,118,31,118,30,118,29,56,31,210,31,145,31,145,30,51,31,97,31,97,30,64,31,19,31,122,31,219,31,219,30,68,31,79,31,79,30,139,31,100,31,111,31,93,31,93,30,147,31,218,31,80,31,86,31,86,30,153,31,171,31,220,31,152,31,11,31,135,31,128,31,198,31,152,31,246,31,133,31,133,30,52,31,56,31,56,30,240,31,115,31,165,31,148,31,152,31,71,31,71,30,58,31,78,31,154,31,185,31,97,31,158,31,158,30,181,31,181,30,181,29,98,31,146,31,102,31,102,30,30,31,51,31,51,30,80,31,80,30,115,31,83,31,117,31,117,30,132,31,164,31,10,31,179,31,179,30,127,31,72,31,202,31,202,30,226,31,90,31,90,30,83,31,174,31,174,30,10,31,10,30,164,31,86,31,40,31,195,31,42,31,101,31,230,31,101,31,226,31,58,31,245,31,138,31,157,31,148,31,108,31,6,31,83,31,83,30,192,31,213,31,95,31,175,31,46,31,95,31,161,31,66,31,177,31,59,31,59,30,59,29,103,31,103,30,156,31,113,31,113,30,73,31,197,31,230,31,230,30,163,31,163,30,132,31,132,30,132,31,85,31,17,31,118,31,67,31,67,30,67,29,24,31,49,31,231,31,236,31,176,31,171,31,54,31,183,31,183,30,183,29,37,31,154,31,133,31,128,31,53,31,53,30,223,31,70,31,217,31,229,31,20,31,136,31,136,30,136,29,165,31,45,31,17,31,17,30,109,31,215,31,61,31,21,31,193,31,197,31,119,31,8,31,17,31,172,31,106,31,106,30,179,31,73,31,99,31,13,31,30,31,30,30,32,31,133,31,133,30,139,31,117,31,237,31,237,30,29,31,153,31,96,31,13,31,119,31,232,31,14,31,14,30,9,31,185,31,78,31,237,31,235,31,89,31,182,31,182,30,48,31,48,30,48,29,148,31,62,31,96,31,50,31,81,31,57,31,49,31,254,31,117,31,113,31,141,31,143,31,110,31,94,31,3,31,3,30,234,31,200,31,18,31,18,30,34,31,34,30,214,31,41,31,183,31,191,31,99,31,117,31,117,30,134,31,65,31,65,30,135,31,167,31,118,31,61,31,10,31,10,30,234,31,144,31,244,31,204,31,244,31,226,31,34,31,8,31,143,31,237,31,186,31,113,31,129,31,10,31,155,31,55,31,108,31,124,31,212,31,98,31,79,31,102,31,255,31,255,30,21,31,66,31,66,30,66,29,209,31,90,31,184,31,184,30,166,31,26,31,203,31,159,31,159,30,110,31,48,31,111,31,111,30,68,31,183,31,230,31,230,30,225,31,67,31,85,31,45,31,8,31,169,31,145,31,86,31,198,31,198,30,198,29,79,31,193,31,68,31,68,30,44,31,120,31,122,31,122,30,249,31,254,31,231,31,179,31,183,31,183,30,183,29,47,31,47,30,142,31,196,31,30,31,223,31,223,30,229,31,229,30,229,29,233,31,33,31,217,31,217,30,72,31,72,30,36,31,141,31,124,31,124,30,60,31,84,31,4,31,55,31,252,31,69,31,69,30,81,31,145,31,27,31,73,31,132,31,24,31,246,31,56,31,22,31,113,31,113,30,119,31,212,31,212,30,103,31,129,31,39,31,39,31,151,31,226,31,193,31,191,31,191,30,222,31,94,31,94,30,94,29,94,28,104,31,182,31,182,30,22,31,17,31,85,31,43,31,4,31,49,31,212,31,212,30,112,31,42,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;

-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_87 is
end project_tb_87;

architecture project_tb_arch_87 of project_tb_87 is
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

constant SCENARIO_LENGTH : integer := 505;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (24,0,160,0,212,0,0,0,38,0,0,0,96,0,231,0,75,0,54,0,172,0,121,0,221,0,49,0,83,0,121,0,29,0,246,0,211,0,210,0,128,0,222,0,0,0,0,0,117,0,19,0,217,0,16,0,172,0,86,0,48,0,239,0,0,0,210,0,233,0,9,0,79,0,0,0,140,0,135,0,11,0,76,0,40,0,89,0,73,0,190,0,0,0,0,0,213,0,0,0,136,0,200,0,0,0,0,0,215,0,119,0,30,0,29,0,97,0,197,0,31,0,176,0,0,0,237,0,80,0,222,0,0,0,0,0,197,0,51,0,33,0,167,0,110,0,185,0,112,0,112,0,197,0,232,0,0,0,167,0,107,0,191,0,0,0,165,0,172,0,221,0,113,0,184,0,21,0,114,0,255,0,141,0,183,0,114,0,158,0,170,0,0,0,52,0,172,0,132,0,157,0,25,0,199,0,14,0,142,0,105,0,0,0,53,0,29,0,137,0,0,0,0,0,160,0,0,0,243,0,124,0,121,0,137,0,101,0,30,0,0,0,1,0,119,0,135,0,226,0,161,0,68,0,136,0,0,0,151,0,156,0,0,0,0,0,76,0,220,0,178,0,11,0,185,0,7,0,246,0,32,0,71,0,176,0,182,0,39,0,240,0,36,0,119,0,12,0,23,0,92,0,73,0,74,0,45,0,238,0,132,0,110,0,21,0,0,0,183,0,168,0,179,0,15,0,222,0,0,0,187,0,19,0,54,0,40,0,221,0,63,0,0,0,209,0,39,0,156,0,57,0,34,0,60,0,0,0,0,0,151,0,66,0,23,0,0,0,26,0,230,0,66,0,55,0,237,0,0,0,33,0,125,0,101,0,231,0,0,0,195,0,53,0,227,0,55,0,218,0,217,0,0,0,164,0,139,0,153,0,191,0,136,0,134,0,38,0,113,0,213,0,0,0,224,0,0,0,137,0,176,0,243,0,0,0,152,0,8,0,79,0,75,0,221,0,83,0,214,0,37,0,124,0,0,0,197,0,72,0,192,0,6,0,213,0,90,0,124,0,136,0,8,0,208,0,0,0,0,0,195,0,170,0,0,0,5,0,36,0,0,0,154,0,0,0,109,0,0,0,95,0,170,0,184,0,63,0,220,0,134,0,235,0,128,0,0,0,7,0,173,0,0,0,124,0,244,0,0,0,82,0,0,0,43,0,71,0,22,0,0,0,232,0,0,0,30,0,223,0,0,0,0,0,161,0,140,0,241,0,2,0,45,0,196,0,0,0,239,0,74,0,238,0,91,0,0,0,128,0,0,0,0,0,124,0,133,0,0,0,18,0,73,0,243,0,35,0,19,0,3,0,89,0,0,0,1,0,197,0,84,0,44,0,221,0,122,0,43,0,212,0,166,0,242,0,0,0,53,0,141,0,122,0,180,0,0,0,165,0,0,0,164,0,54,0,50,0,49,0,213,0,209,0,106,0,90,0,213,0,198,0,218,0,84,0,0,0,37,0,186,0,0,0,166,0,152,0,152,0,111,0,113,0,239,0,135,0,4,0,123,0,35,0,71,0,3,0,199,0,58,0,136,0,143,0,234,0,69,0,177,0,96,0,253,0,152,0,143,0,0,0,57,0,198,0,0,0,241,0,0,0,138,0,0,0,248,0,31,0,200,0,228,0,202,0,102,0,57,0,197,0,2,0,0,0,0,0,84,0,0,0,149,0,182,0,164,0,0,0,69,0,0,0,0,0,133,0,198,0,71,0,125,0,9,0,120,0,136,0,72,0,196,0,236,0,78,0,116,0,32,0,239,0,0,0,131,0,100,0,76,0,127,0,175,0,30,0,104,0,167,0,161,0,134,0,65,0,125,0,59,0,203,0,223,0,254,0,0,0,134,0,36,0,12,0,175,0,192,0,128,0,167,0,0,0,196,0,196,0,237,0,107,0,9,0,185,0,184,0,0,0,121,0,71,0,148,0,60,0,182,0,112,0,127,0,182,0,181,0,0,0,0,0,0,0,141,0,102,0,77,0,246,0,142,0,22,0,54,0,102,0,203,0,17,0,0,0,253,0,232,0,140,0,0,0,35,0,48,0,45,0,0,0,236,0,17,0,0,0,146,0,0,0,15,0,101,0,130,0,223,0,219,0,46,0,248,0,223,0,83,0,0,0,89,0,0,0,234,0,221,0,87,0,244,0,248,0,132,0,77,0,234,0,145,0,178,0,6,0,102,0,228,0,0,0,28,0,65,0,0,0,92,0,34,0,237,0,248,0);
signal scenario_full  : scenario_type := (24,31,160,31,212,31,212,30,38,31,38,30,96,31,231,31,75,31,54,31,172,31,121,31,221,31,49,31,83,31,121,31,29,31,246,31,211,31,210,31,128,31,222,31,222,30,222,29,117,31,19,31,217,31,16,31,172,31,86,31,48,31,239,31,239,30,210,31,233,31,9,31,79,31,79,30,140,31,135,31,11,31,76,31,40,31,89,31,73,31,190,31,190,30,190,29,213,31,213,30,136,31,200,31,200,30,200,29,215,31,119,31,30,31,29,31,97,31,197,31,31,31,176,31,176,30,237,31,80,31,222,31,222,30,222,29,197,31,51,31,33,31,167,31,110,31,185,31,112,31,112,31,197,31,232,31,232,30,167,31,107,31,191,31,191,30,165,31,172,31,221,31,113,31,184,31,21,31,114,31,255,31,141,31,183,31,114,31,158,31,170,31,170,30,52,31,172,31,132,31,157,31,25,31,199,31,14,31,142,31,105,31,105,30,53,31,29,31,137,31,137,30,137,29,160,31,160,30,243,31,124,31,121,31,137,31,101,31,30,31,30,30,1,31,119,31,135,31,226,31,161,31,68,31,136,31,136,30,151,31,156,31,156,30,156,29,76,31,220,31,178,31,11,31,185,31,7,31,246,31,32,31,71,31,176,31,182,31,39,31,240,31,36,31,119,31,12,31,23,31,92,31,73,31,74,31,45,31,238,31,132,31,110,31,21,31,21,30,183,31,168,31,179,31,15,31,222,31,222,30,187,31,19,31,54,31,40,31,221,31,63,31,63,30,209,31,39,31,156,31,57,31,34,31,60,31,60,30,60,29,151,31,66,31,23,31,23,30,26,31,230,31,66,31,55,31,237,31,237,30,33,31,125,31,101,31,231,31,231,30,195,31,53,31,227,31,55,31,218,31,217,31,217,30,164,31,139,31,153,31,191,31,136,31,134,31,38,31,113,31,213,31,213,30,224,31,224,30,137,31,176,31,243,31,243,30,152,31,8,31,79,31,75,31,221,31,83,31,214,31,37,31,124,31,124,30,197,31,72,31,192,31,6,31,213,31,90,31,124,31,136,31,8,31,208,31,208,30,208,29,195,31,170,31,170,30,5,31,36,31,36,30,154,31,154,30,109,31,109,30,95,31,170,31,184,31,63,31,220,31,134,31,235,31,128,31,128,30,7,31,173,31,173,30,124,31,244,31,244,30,82,31,82,30,43,31,71,31,22,31,22,30,232,31,232,30,30,31,223,31,223,30,223,29,161,31,140,31,241,31,2,31,45,31,196,31,196,30,239,31,74,31,238,31,91,31,91,30,128,31,128,30,128,29,124,31,133,31,133,30,18,31,73,31,243,31,35,31,19,31,3,31,89,31,89,30,1,31,197,31,84,31,44,31,221,31,122,31,43,31,212,31,166,31,242,31,242,30,53,31,141,31,122,31,180,31,180,30,165,31,165,30,164,31,54,31,50,31,49,31,213,31,209,31,106,31,90,31,213,31,198,31,218,31,84,31,84,30,37,31,186,31,186,30,166,31,152,31,152,31,111,31,113,31,239,31,135,31,4,31,123,31,35,31,71,31,3,31,199,31,58,31,136,31,143,31,234,31,69,31,177,31,96,31,253,31,152,31,143,31,143,30,57,31,198,31,198,30,241,31,241,30,138,31,138,30,248,31,31,31,200,31,228,31,202,31,102,31,57,31,197,31,2,31,2,30,2,29,84,31,84,30,149,31,182,31,164,31,164,30,69,31,69,30,69,29,133,31,198,31,71,31,125,31,9,31,120,31,136,31,72,31,196,31,236,31,78,31,116,31,32,31,239,31,239,30,131,31,100,31,76,31,127,31,175,31,30,31,104,31,167,31,161,31,134,31,65,31,125,31,59,31,203,31,223,31,254,31,254,30,134,31,36,31,12,31,175,31,192,31,128,31,167,31,167,30,196,31,196,31,237,31,107,31,9,31,185,31,184,31,184,30,121,31,71,31,148,31,60,31,182,31,112,31,127,31,182,31,181,31,181,30,181,29,181,28,141,31,102,31,77,31,246,31,142,31,22,31,54,31,102,31,203,31,17,31,17,30,253,31,232,31,140,31,140,30,35,31,48,31,45,31,45,30,236,31,17,31,17,30,146,31,146,30,15,31,101,31,130,31,223,31,219,31,46,31,248,31,223,31,83,31,83,30,89,31,89,30,234,31,221,31,87,31,244,31,248,31,132,31,77,31,234,31,145,31,178,31,6,31,102,31,228,31,228,30,28,31,65,31,65,30,92,31,34,31,237,31,248,31);

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

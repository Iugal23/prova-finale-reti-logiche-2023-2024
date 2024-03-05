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

constant SCENARIO_LENGTH : integer := 539;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,22,0,102,0,219,0,0,0,70,0,96,0,55,0,38,0,23,0,0,0,19,0,9,0,190,0,52,0,101,0,185,0,158,0,213,0,179,0,83,0,53,0,0,0,98,0,45,0,57,0,252,0,51,0,0,0,169,0,19,0,163,0,223,0,184,0,146,0,101,0,40,0,2,0,0,0,251,0,172,0,223,0,198,0,0,0,59,0,0,0,0,0,90,0,217,0,116,0,243,0,0,0,8,0,248,0,0,0,181,0,231,0,249,0,188,0,192,0,225,0,228,0,204,0,226,0,101,0,0,0,102,0,0,0,2,0,197,0,246,0,62,0,205,0,182,0,241,0,0,0,224,0,0,0,35,0,238,0,65,0,240,0,43,0,73,0,48,0,147,0,0,0,113,0,0,0,41,0,31,0,140,0,0,0,122,0,11,0,117,0,47,0,197,0,75,0,203,0,79,0,49,0,65,0,235,0,159,0,136,0,0,0,57,0,189,0,99,0,217,0,222,0,125,0,178,0,245,0,64,0,89,0,234,0,70,0,18,0,15,0,0,0,244,0,251,0,232,0,0,0,0,0,36,0,111,0,101,0,160,0,87,0,33,0,202,0,135,0,124,0,86,0,0,0,192,0,24,0,21,0,127,0,206,0,75,0,0,0,119,0,22,0,222,0,93,0,0,0,0,0,167,0,79,0,213,0,17,0,25,0,0,0,94,0,96,0,244,0,40,0,255,0,0,0,0,0,112,0,239,0,243,0,13,0,224,0,100,0,48,0,92,0,184,0,17,0,153,0,94,0,76,0,0,0,50,0,0,0,53,0,188,0,3,0,100,0,149,0,0,0,77,0,170,0,183,0,132,0,7,0,126,0,219,0,0,0,155,0,4,0,3,0,65,0,245,0,151,0,151,0,153,0,187,0,83,0,79,0,136,0,7,0,13,0,216,0,0,0,75,0,221,0,118,0,73,0,0,0,56,0,189,0,0,0,0,0,149,0,0,0,37,0,147,0,141,0,98,0,199,0,0,0,247,0,146,0,164,0,0,0,76,0,166,0,237,0,0,0,242,0,148,0,57,0,213,0,86,0,0,0,35,0,93,0,203,0,101,0,97,0,142,0,117,0,193,0,174,0,136,0,20,0,0,0,27,0,217,0,210,0,212,0,155,0,23,0,0,0,75,0,251,0,0,0,121,0,235,0,6,0,75,0,0,0,83,0,0,0,94,0,165,0,237,0,50,0,157,0,69,0,206,0,0,0,0,0,160,0,67,0,201,0,57,0,229,0,208,0,25,0,30,0,0,0,6,0,52,0,206,0,104,0,165,0,165,0,220,0,97,0,30,0,99,0,71,0,168,0,0,0,174,0,130,0,187,0,3,0,79,0,192,0,181,0,0,0,241,0,209,0,72,0,0,0,0,0,167,0,233,0,41,0,74,0,35,0,0,0,233,0,217,0,254,0,168,0,164,0,15,0,143,0,173,0,169,0,124,0,235,0,164,0,0,0,124,0,44,0,247,0,26,0,0,0,22,0,70,0,213,0,35,0,90,0,0,0,0,0,148,0,25,0,125,0,200,0,226,0,98,0,5,0,90,0,158,0,124,0,248,0,0,0,90,0,42,0,14,0,78,0,0,0,0,0,99,0,43,0,7,0,197,0,20,0,231,0,45,0,44,0,79,0,180,0,48,0,116,0,0,0,0,0,0,0,0,0,194,0,228,0,72,0,116,0,161,0,0,0,0,0,250,0,215,0,243,0,218,0,240,0,35,0,223,0,159,0,8,0,192,0,233,0,169,0,86,0,0,0,0,0,0,0,19,0,218,0,0,0,8,0,0,0,0,0,0,0,125,0,91,0,155,0,0,0,92,0,0,0,0,0,2,0,128,0,159,0,14,0,0,0,218,0,0,0,92,0,123,0,207,0,205,0,70,0,131,0,57,0,181,0,0,0,198,0,163,0,82,0,0,0,159,0,172,0,177,0,132,0,0,0,63,0,232,0,176,0,41,0,160,0,191,0,0,0,0,0,239,0,218,0,138,0,202,0,163,0,153,0,35,0,25,0,73,0,0,0,96,0,139,0,5,0,0,0,250,0,0,0,168,0,205,0,194,0,66,0,43,0,72,0,232,0,41,0,20,0,203,0,206,0,44,0,0,0,36,0,81,0,197,0,131,0,126,0,20,0,91,0,80,0,127,0,0,0,97,0,204,0,195,0,181,0,46,0,197,0,8,0,119,0,6,0,85,0,0,0,195,0,0,0,95,0,55,0,96,0,250,0,209,0,219,0,173,0,36,0,0,0,0,0,92,0,0,0,102,0,139,0,103,0,104,0,72,0,168,0,0,0,99,0,87,0,4,0,70,0,0,0,113,0,90,0,7,0,140,0,147,0,4,0,237,0,201,0,240,0,196,0,0,0,0,0,140,0,253,0);
signal scenario_full  : scenario_type := (0,0,22,31,102,31,219,31,219,30,70,31,96,31,55,31,38,31,23,31,23,30,19,31,9,31,190,31,52,31,101,31,185,31,158,31,213,31,179,31,83,31,53,31,53,30,98,31,45,31,57,31,252,31,51,31,51,30,169,31,19,31,163,31,223,31,184,31,146,31,101,31,40,31,2,31,2,30,251,31,172,31,223,31,198,31,198,30,59,31,59,30,59,29,90,31,217,31,116,31,243,31,243,30,8,31,248,31,248,30,181,31,231,31,249,31,188,31,192,31,225,31,228,31,204,31,226,31,101,31,101,30,102,31,102,30,2,31,197,31,246,31,62,31,205,31,182,31,241,31,241,30,224,31,224,30,35,31,238,31,65,31,240,31,43,31,73,31,48,31,147,31,147,30,113,31,113,30,41,31,31,31,140,31,140,30,122,31,11,31,117,31,47,31,197,31,75,31,203,31,79,31,49,31,65,31,235,31,159,31,136,31,136,30,57,31,189,31,99,31,217,31,222,31,125,31,178,31,245,31,64,31,89,31,234,31,70,31,18,31,15,31,15,30,244,31,251,31,232,31,232,30,232,29,36,31,111,31,101,31,160,31,87,31,33,31,202,31,135,31,124,31,86,31,86,30,192,31,24,31,21,31,127,31,206,31,75,31,75,30,119,31,22,31,222,31,93,31,93,30,93,29,167,31,79,31,213,31,17,31,25,31,25,30,94,31,96,31,244,31,40,31,255,31,255,30,255,29,112,31,239,31,243,31,13,31,224,31,100,31,48,31,92,31,184,31,17,31,153,31,94,31,76,31,76,30,50,31,50,30,53,31,188,31,3,31,100,31,149,31,149,30,77,31,170,31,183,31,132,31,7,31,126,31,219,31,219,30,155,31,4,31,3,31,65,31,245,31,151,31,151,31,153,31,187,31,83,31,79,31,136,31,7,31,13,31,216,31,216,30,75,31,221,31,118,31,73,31,73,30,56,31,189,31,189,30,189,29,149,31,149,30,37,31,147,31,141,31,98,31,199,31,199,30,247,31,146,31,164,31,164,30,76,31,166,31,237,31,237,30,242,31,148,31,57,31,213,31,86,31,86,30,35,31,93,31,203,31,101,31,97,31,142,31,117,31,193,31,174,31,136,31,20,31,20,30,27,31,217,31,210,31,212,31,155,31,23,31,23,30,75,31,251,31,251,30,121,31,235,31,6,31,75,31,75,30,83,31,83,30,94,31,165,31,237,31,50,31,157,31,69,31,206,31,206,30,206,29,160,31,67,31,201,31,57,31,229,31,208,31,25,31,30,31,30,30,6,31,52,31,206,31,104,31,165,31,165,31,220,31,97,31,30,31,99,31,71,31,168,31,168,30,174,31,130,31,187,31,3,31,79,31,192,31,181,31,181,30,241,31,209,31,72,31,72,30,72,29,167,31,233,31,41,31,74,31,35,31,35,30,233,31,217,31,254,31,168,31,164,31,15,31,143,31,173,31,169,31,124,31,235,31,164,31,164,30,124,31,44,31,247,31,26,31,26,30,22,31,70,31,213,31,35,31,90,31,90,30,90,29,148,31,25,31,125,31,200,31,226,31,98,31,5,31,90,31,158,31,124,31,248,31,248,30,90,31,42,31,14,31,78,31,78,30,78,29,99,31,43,31,7,31,197,31,20,31,231,31,45,31,44,31,79,31,180,31,48,31,116,31,116,30,116,29,116,28,116,27,194,31,228,31,72,31,116,31,161,31,161,30,161,29,250,31,215,31,243,31,218,31,240,31,35,31,223,31,159,31,8,31,192,31,233,31,169,31,86,31,86,30,86,29,86,28,19,31,218,31,218,30,8,31,8,30,8,29,8,28,125,31,91,31,155,31,155,30,92,31,92,30,92,29,2,31,128,31,159,31,14,31,14,30,218,31,218,30,92,31,123,31,207,31,205,31,70,31,131,31,57,31,181,31,181,30,198,31,163,31,82,31,82,30,159,31,172,31,177,31,132,31,132,30,63,31,232,31,176,31,41,31,160,31,191,31,191,30,191,29,239,31,218,31,138,31,202,31,163,31,153,31,35,31,25,31,73,31,73,30,96,31,139,31,5,31,5,30,250,31,250,30,168,31,205,31,194,31,66,31,43,31,72,31,232,31,41,31,20,31,203,31,206,31,44,31,44,30,36,31,81,31,197,31,131,31,126,31,20,31,91,31,80,31,127,31,127,30,97,31,204,31,195,31,181,31,46,31,197,31,8,31,119,31,6,31,85,31,85,30,195,31,195,30,95,31,55,31,96,31,250,31,209,31,219,31,173,31,36,31,36,30,36,29,92,31,92,30,102,31,139,31,103,31,104,31,72,31,168,31,168,30,99,31,87,31,4,31,70,31,70,30,113,31,90,31,7,31,140,31,147,31,4,31,237,31,201,31,240,31,196,31,196,30,196,29,140,31,253,31);

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

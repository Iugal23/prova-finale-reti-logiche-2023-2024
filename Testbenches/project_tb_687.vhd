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

constant SCENARIO_LENGTH : integer := 537;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (251,0,131,0,245,0,176,0,18,0,0,0,195,0,217,0,114,0,137,0,203,0,159,0,0,0,181,0,7,0,91,0,119,0,219,0,84,0,103,0,94,0,76,0,17,0,128,0,109,0,3,0,227,0,135,0,6,0,0,0,18,0,0,0,148,0,0,0,231,0,61,0,233,0,0,0,18,0,111,0,0,0,58,0,101,0,0,0,67,0,0,0,117,0,22,0,102,0,173,0,217,0,79,0,96,0,136,0,25,0,93,0,48,0,119,0,104,0,240,0,102,0,59,0,39,0,215,0,88,0,0,0,0,0,238,0,216,0,125,0,68,0,98,0,63,0,103,0,0,0,186,0,4,0,0,0,117,0,0,0,243,0,80,0,163,0,168,0,186,0,0,0,63,0,93,0,105,0,99,0,205,0,132,0,29,0,86,0,129,0,206,0,86,0,207,0,60,0,216,0,121,0,181,0,39,0,50,0,50,0,170,0,48,0,25,0,0,0,11,0,0,0,0,0,162,0,34,0,0,0,0,0,175,0,0,0,202,0,28,0,237,0,0,0,212,0,80,0,0,0,208,0,203,0,73,0,49,0,237,0,200,0,15,0,189,0,112,0,100,0,177,0,0,0,98,0,169,0,60,0,0,0,0,0,151,0,76,0,215,0,176,0,27,0,228,0,0,0,44,0,0,0,0,0,46,0,247,0,38,0,7,0,172,0,170,0,41,0,71,0,211,0,83,0,0,0,0,0,109,0,64,0,158,0,35,0,79,0,26,0,58,0,132,0,0,0,105,0,250,0,0,0,169,0,31,0,205,0,140,0,0,0,243,0,70,0,133,0,254,0,52,0,121,0,0,0,31,0,26,0,20,0,108,0,29,0,189,0,0,0,72,0,219,0,0,0,0,0,72,0,175,0,52,0,238,0,38,0,139,0,54,0,0,0,112,0,101,0,0,0,0,0,248,0,0,0,0,0,49,0,24,0,0,0,150,0,0,0,144,0,0,0,0,0,192,0,158,0,180,0,59,0,24,0,216,0,233,0,194,0,219,0,135,0,203,0,111,0,0,0,221,0,0,0,99,0,0,0,26,0,113,0,148,0,0,0,0,0,138,0,58,0,112,0,135,0,132,0,194,0,0,0,0,0,231,0,220,0,175,0,178,0,88,0,233,0,46,0,0,0,0,0,0,0,90,0,0,0,154,0,0,0,12,0,147,0,33,0,154,0,233,0,0,0,0,0,116,0,201,0,31,0,195,0,248,0,245,0,179,0,85,0,0,0,103,0,0,0,16,0,149,0,111,0,32,0,149,0,0,0,1,0,150,0,113,0,201,0,202,0,47,0,170,0,130,0,107,0,203,0,74,0,35,0,170,0,55,0,222,0,131,0,0,0,0,0,0,0,152,0,0,0,214,0,213,0,82,0,77,0,243,0,12,0,187,0,0,0,40,0,77,0,12,0,0,0,92,0,75,0,103,0,200,0,225,0,51,0,252,0,0,0,228,0,5,0,0,0,0,0,197,0,147,0,30,0,230,0,116,0,101,0,247,0,0,0,45,0,171,0,252,0,253,0,73,0,48,0,114,0,11,0,61,0,14,0,122,0,0,0,21,0,121,0,232,0,238,0,49,0,175,0,239,0,203,0,255,0,230,0,102,0,178,0,186,0,242,0,112,0,98,0,119,0,205,0,169,0,9,0,83,0,143,0,10,0,85,0,252,0,17,0,187,0,101,0,141,0,0,0,69,0,20,0,139,0,169,0,0,0,228,0,0,0,193,0,30,0,35,0,50,0,163,0,141,0,0,0,0,0,34,0,173,0,0,0,62,0,234,0,0,0,143,0,123,0,236,0,241,0,126,0,20,0,29,0,207,0,221,0,0,0,155,0,7,0,154,0,215,0,0,0,130,0,24,0,114,0,139,0,3,0,0,0,17,0,251,0,117,0,56,0,6,0,28,0,0,0,3,0,38,0,208,0,113,0,28,0,222,0,0,0,4,0,251,0,250,0,89,0,0,0,189,0,170,0,159,0,74,0,149,0,102,0,112,0,4,0,38,0,63,0,234,0,189,0,89,0,123,0,104,0,131,0,185,0,214,0,169,0,154,0,32,0,113,0,136,0,152,0,14,0,56,0,43,0,180,0,38,0,23,0,240,0,99,0,0,0,174,0,212,0,55,0,206,0,157,0,10,0,241,0,183,0,239,0,0,0,111,0,0,0,187,0,242,0,119,0,49,0,179,0,0,0,159,0,27,0,120,0,161,0,0,0,19,0,141,0,118,0,179,0,74,0,0,0,188,0,228,0,8,0,0,0,0,0,226,0,76,0,6,0,0,0,0,0,219,0,151,0,74,0,14,0,123,0,198,0,30,0,38,0,207,0,0,0,150,0,0,0,63,0,0,0,198,0,0,0,51,0,152,0,193,0);
signal scenario_full  : scenario_type := (251,31,131,31,245,31,176,31,18,31,18,30,195,31,217,31,114,31,137,31,203,31,159,31,159,30,181,31,7,31,91,31,119,31,219,31,84,31,103,31,94,31,76,31,17,31,128,31,109,31,3,31,227,31,135,31,6,31,6,30,18,31,18,30,148,31,148,30,231,31,61,31,233,31,233,30,18,31,111,31,111,30,58,31,101,31,101,30,67,31,67,30,117,31,22,31,102,31,173,31,217,31,79,31,96,31,136,31,25,31,93,31,48,31,119,31,104,31,240,31,102,31,59,31,39,31,215,31,88,31,88,30,88,29,238,31,216,31,125,31,68,31,98,31,63,31,103,31,103,30,186,31,4,31,4,30,117,31,117,30,243,31,80,31,163,31,168,31,186,31,186,30,63,31,93,31,105,31,99,31,205,31,132,31,29,31,86,31,129,31,206,31,86,31,207,31,60,31,216,31,121,31,181,31,39,31,50,31,50,31,170,31,48,31,25,31,25,30,11,31,11,30,11,29,162,31,34,31,34,30,34,29,175,31,175,30,202,31,28,31,237,31,237,30,212,31,80,31,80,30,208,31,203,31,73,31,49,31,237,31,200,31,15,31,189,31,112,31,100,31,177,31,177,30,98,31,169,31,60,31,60,30,60,29,151,31,76,31,215,31,176,31,27,31,228,31,228,30,44,31,44,30,44,29,46,31,247,31,38,31,7,31,172,31,170,31,41,31,71,31,211,31,83,31,83,30,83,29,109,31,64,31,158,31,35,31,79,31,26,31,58,31,132,31,132,30,105,31,250,31,250,30,169,31,31,31,205,31,140,31,140,30,243,31,70,31,133,31,254,31,52,31,121,31,121,30,31,31,26,31,20,31,108,31,29,31,189,31,189,30,72,31,219,31,219,30,219,29,72,31,175,31,52,31,238,31,38,31,139,31,54,31,54,30,112,31,101,31,101,30,101,29,248,31,248,30,248,29,49,31,24,31,24,30,150,31,150,30,144,31,144,30,144,29,192,31,158,31,180,31,59,31,24,31,216,31,233,31,194,31,219,31,135,31,203,31,111,31,111,30,221,31,221,30,99,31,99,30,26,31,113,31,148,31,148,30,148,29,138,31,58,31,112,31,135,31,132,31,194,31,194,30,194,29,231,31,220,31,175,31,178,31,88,31,233,31,46,31,46,30,46,29,46,28,90,31,90,30,154,31,154,30,12,31,147,31,33,31,154,31,233,31,233,30,233,29,116,31,201,31,31,31,195,31,248,31,245,31,179,31,85,31,85,30,103,31,103,30,16,31,149,31,111,31,32,31,149,31,149,30,1,31,150,31,113,31,201,31,202,31,47,31,170,31,130,31,107,31,203,31,74,31,35,31,170,31,55,31,222,31,131,31,131,30,131,29,131,28,152,31,152,30,214,31,213,31,82,31,77,31,243,31,12,31,187,31,187,30,40,31,77,31,12,31,12,30,92,31,75,31,103,31,200,31,225,31,51,31,252,31,252,30,228,31,5,31,5,30,5,29,197,31,147,31,30,31,230,31,116,31,101,31,247,31,247,30,45,31,171,31,252,31,253,31,73,31,48,31,114,31,11,31,61,31,14,31,122,31,122,30,21,31,121,31,232,31,238,31,49,31,175,31,239,31,203,31,255,31,230,31,102,31,178,31,186,31,242,31,112,31,98,31,119,31,205,31,169,31,9,31,83,31,143,31,10,31,85,31,252,31,17,31,187,31,101,31,141,31,141,30,69,31,20,31,139,31,169,31,169,30,228,31,228,30,193,31,30,31,35,31,50,31,163,31,141,31,141,30,141,29,34,31,173,31,173,30,62,31,234,31,234,30,143,31,123,31,236,31,241,31,126,31,20,31,29,31,207,31,221,31,221,30,155,31,7,31,154,31,215,31,215,30,130,31,24,31,114,31,139,31,3,31,3,30,17,31,251,31,117,31,56,31,6,31,28,31,28,30,3,31,38,31,208,31,113,31,28,31,222,31,222,30,4,31,251,31,250,31,89,31,89,30,189,31,170,31,159,31,74,31,149,31,102,31,112,31,4,31,38,31,63,31,234,31,189,31,89,31,123,31,104,31,131,31,185,31,214,31,169,31,154,31,32,31,113,31,136,31,152,31,14,31,56,31,43,31,180,31,38,31,23,31,240,31,99,31,99,30,174,31,212,31,55,31,206,31,157,31,10,31,241,31,183,31,239,31,239,30,111,31,111,30,187,31,242,31,119,31,49,31,179,31,179,30,159,31,27,31,120,31,161,31,161,30,19,31,141,31,118,31,179,31,74,31,74,30,188,31,228,31,8,31,8,30,8,29,226,31,76,31,6,31,6,30,6,29,219,31,151,31,74,31,14,31,123,31,198,31,30,31,38,31,207,31,207,30,150,31,150,30,63,31,63,30,198,31,198,30,51,31,152,31,193,31);

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

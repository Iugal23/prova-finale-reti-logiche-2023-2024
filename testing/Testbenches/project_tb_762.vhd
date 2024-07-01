-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_762 is
end project_tb_762;

architecture project_tb_arch_762 of project_tb_762 is
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

constant SCENARIO_LENGTH : integer := 581;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,0,0,208,0,23,0,136,0,0,0,146,0,49,0,55,0,0,0,92,0,0,0,0,0,53,0,41,0,128,0,11,0,76,0,0,0,254,0,216,0,0,0,0,0,159,0,0,0,161,0,52,0,111,0,92,0,107,0,100,0,212,0,193,0,71,0,96,0,230,0,203,0,0,0,25,0,238,0,95,0,3,0,139,0,139,0,7,0,22,0,169,0,0,0,3,0,97,0,151,0,47,0,244,0,0,0,191,0,253,0,10,0,0,0,240,0,252,0,55,0,243,0,0,0,180,0,186,0,203,0,117,0,133,0,14,0,124,0,154,0,240,0,0,0,76,0,244,0,163,0,0,0,39,0,0,0,26,0,198,0,146,0,37,0,24,0,144,0,63,0,41,0,0,0,142,0,62,0,254,0,220,0,0,0,23,0,210,0,14,0,0,0,0,0,5,0,155,0,56,0,0,0,104,0,36,0,23,0,45,0,56,0,177,0,0,0,139,0,62,0,0,0,0,0,198,0,151,0,216,0,3,0,251,0,38,0,133,0,163,0,180,0,55,0,217,0,163,0,114,0,189,0,4,0,188,0,112,0,38,0,195,0,102,0,0,0,133,0,0,0,61,0,214,0,0,0,54,0,127,0,225,0,114,0,64,0,0,0,118,0,125,0,207,0,60,0,240,0,214,0,28,0,197,0,210,0,35,0,0,0,0,0,69,0,0,0,155,0,61,0,126,0,213,0,0,0,227,0,91,0,213,0,0,0,216,0,148,0,0,0,23,0,72,0,147,0,77,0,158,0,0,0,165,0,0,0,170,0,213,0,149,0,253,0,30,0,181,0,118,0,134,0,253,0,145,0,0,0,20,0,0,0,216,0,0,0,206,0,203,0,88,0,144,0,135,0,32,0,134,0,213,0,0,0,188,0,218,0,95,0,190,0,241,0,81,0,72,0,225,0,108,0,39,0,0,0,178,0,82,0,225,0,227,0,241,0,172,0,85,0,181,0,122,0,75,0,6,0,157,0,220,0,122,0,76,0,160,0,232,0,26,0,0,0,230,0,0,0,0,0,81,0,0,0,184,0,0,0,7,0,0,0,49,0,202,0,195,0,34,0,206,0,83,0,252,0,37,0,0,0,0,0,13,0,159,0,0,0,240,0,154,0,193,0,95,0,73,0,0,0,190,0,22,0,217,0,40,0,66,0,135,0,224,0,30,0,0,0,236,0,99,0,119,0,203,0,0,0,0,0,51,0,182,0,0,0,36,0,124,0,101,0,57,0,242,0,38,0,238,0,210,0,40,0,203,0,0,0,0,0,12,0,86,0,72,0,159,0,223,0,251,0,97,0,0,0,187,0,161,0,210,0,4,0,0,0,112,0,146,0,13,0,28,0,230,0,202,0,203,0,228,0,48,0,195,0,59,0,83,0,0,0,69,0,0,0,16,0,144,0,95,0,245,0,0,0,0,0,87,0,0,0,169,0,4,0,0,0,50,0,181,0,0,0,0,0,0,0,0,0,115,0,225,0,98,0,0,0,109,0,0,0,112,0,0,0,77,0,0,0,163,0,6,0,104,0,67,0,109,0,50,0,218,0,210,0,0,0,219,0,140,0,172,0,160,0,73,0,208,0,0,0,0,0,70,0,55,0,225,0,44,0,107,0,122,0,0,0,215,0,0,0,216,0,168,0,112,0,138,0,180,0,120,0,188,0,220,0,184,0,240,0,184,0,193,0,180,0,0,0,116,0,95,0,234,0,0,0,16,0,193,0,72,0,212,0,187,0,108,0,152,0,0,0,0,0,72,0,0,0,122,0,0,0,142,0,123,0,101,0,172,0,253,0,91,0,0,0,250,0,124,0,3,0,177,0,95,0,148,0,171,0,7,0,0,0,31,0,26,0,79,0,0,0,192,0,0,0,0,0,90,0,15,0,13,0,138,0,41,0,78,0,0,0,18,0,62,0,108,0,147,0,0,0,195,0,0,0,47,0,68,0,32,0,10,0,109,0,195,0,0,0,66,0,0,0,23,0,38,0,191,0,0,0,46,0,239,0,34,0,251,0,136,0,91,0,85,0,175,0,81,0,111,0,0,0,190,0,109,0,19,0,250,0,189,0,107,0,0,0,235,0,23,0,248,0,3,0,93,0,255,0,166,0,65,0,164,0,225,0,138,0,237,0,12,0,94,0,251,0,0,0,116,0,0,0,0,0,134,0,21,0,123,0,185,0,0,0,120,0,0,0,54,0,247,0,44,0,26,0,142,0,105,0,118,0,216,0,222,0,180,0,208,0,228,0,161,0,0,0,210,0,49,0,192,0,171,0,30,0,231,0,244,0,0,0,202,0,0,0,255,0,184,0,109,0,114,0,179,0,91,0,94,0,0,0,248,0,0,0,0,0,0,0,226,0,159,0,65,0,4,0,172,0,114,0,195,0,210,0,34,0,0,0,243,0,28,0,241,0,75,0,81,0,63,0,152,0,85,0,217,0,165,0,179,0,231,0,135,0,207,0,148,0,174,0,0,0,47,0,89,0,149,0,98,0,21,0,245,0,30,0,158,0,0,0,23,0,29,0,251,0,56,0,135,0,199,0,0,0,20,0,84,0,222,0,149,0,53,0);
signal scenario_full  : scenario_type := (0,0,0,0,208,31,23,31,136,31,136,30,146,31,49,31,55,31,55,30,92,31,92,30,92,29,53,31,41,31,128,31,11,31,76,31,76,30,254,31,216,31,216,30,216,29,159,31,159,30,161,31,52,31,111,31,92,31,107,31,100,31,212,31,193,31,71,31,96,31,230,31,203,31,203,30,25,31,238,31,95,31,3,31,139,31,139,31,7,31,22,31,169,31,169,30,3,31,97,31,151,31,47,31,244,31,244,30,191,31,253,31,10,31,10,30,240,31,252,31,55,31,243,31,243,30,180,31,186,31,203,31,117,31,133,31,14,31,124,31,154,31,240,31,240,30,76,31,244,31,163,31,163,30,39,31,39,30,26,31,198,31,146,31,37,31,24,31,144,31,63,31,41,31,41,30,142,31,62,31,254,31,220,31,220,30,23,31,210,31,14,31,14,30,14,29,5,31,155,31,56,31,56,30,104,31,36,31,23,31,45,31,56,31,177,31,177,30,139,31,62,31,62,30,62,29,198,31,151,31,216,31,3,31,251,31,38,31,133,31,163,31,180,31,55,31,217,31,163,31,114,31,189,31,4,31,188,31,112,31,38,31,195,31,102,31,102,30,133,31,133,30,61,31,214,31,214,30,54,31,127,31,225,31,114,31,64,31,64,30,118,31,125,31,207,31,60,31,240,31,214,31,28,31,197,31,210,31,35,31,35,30,35,29,69,31,69,30,155,31,61,31,126,31,213,31,213,30,227,31,91,31,213,31,213,30,216,31,148,31,148,30,23,31,72,31,147,31,77,31,158,31,158,30,165,31,165,30,170,31,213,31,149,31,253,31,30,31,181,31,118,31,134,31,253,31,145,31,145,30,20,31,20,30,216,31,216,30,206,31,203,31,88,31,144,31,135,31,32,31,134,31,213,31,213,30,188,31,218,31,95,31,190,31,241,31,81,31,72,31,225,31,108,31,39,31,39,30,178,31,82,31,225,31,227,31,241,31,172,31,85,31,181,31,122,31,75,31,6,31,157,31,220,31,122,31,76,31,160,31,232,31,26,31,26,30,230,31,230,30,230,29,81,31,81,30,184,31,184,30,7,31,7,30,49,31,202,31,195,31,34,31,206,31,83,31,252,31,37,31,37,30,37,29,13,31,159,31,159,30,240,31,154,31,193,31,95,31,73,31,73,30,190,31,22,31,217,31,40,31,66,31,135,31,224,31,30,31,30,30,236,31,99,31,119,31,203,31,203,30,203,29,51,31,182,31,182,30,36,31,124,31,101,31,57,31,242,31,38,31,238,31,210,31,40,31,203,31,203,30,203,29,12,31,86,31,72,31,159,31,223,31,251,31,97,31,97,30,187,31,161,31,210,31,4,31,4,30,112,31,146,31,13,31,28,31,230,31,202,31,203,31,228,31,48,31,195,31,59,31,83,31,83,30,69,31,69,30,16,31,144,31,95,31,245,31,245,30,245,29,87,31,87,30,169,31,4,31,4,30,50,31,181,31,181,30,181,29,181,28,181,27,115,31,225,31,98,31,98,30,109,31,109,30,112,31,112,30,77,31,77,30,163,31,6,31,104,31,67,31,109,31,50,31,218,31,210,31,210,30,219,31,140,31,172,31,160,31,73,31,208,31,208,30,208,29,70,31,55,31,225,31,44,31,107,31,122,31,122,30,215,31,215,30,216,31,168,31,112,31,138,31,180,31,120,31,188,31,220,31,184,31,240,31,184,31,193,31,180,31,180,30,116,31,95,31,234,31,234,30,16,31,193,31,72,31,212,31,187,31,108,31,152,31,152,30,152,29,72,31,72,30,122,31,122,30,142,31,123,31,101,31,172,31,253,31,91,31,91,30,250,31,124,31,3,31,177,31,95,31,148,31,171,31,7,31,7,30,31,31,26,31,79,31,79,30,192,31,192,30,192,29,90,31,15,31,13,31,138,31,41,31,78,31,78,30,18,31,62,31,108,31,147,31,147,30,195,31,195,30,47,31,68,31,32,31,10,31,109,31,195,31,195,30,66,31,66,30,23,31,38,31,191,31,191,30,46,31,239,31,34,31,251,31,136,31,91,31,85,31,175,31,81,31,111,31,111,30,190,31,109,31,19,31,250,31,189,31,107,31,107,30,235,31,23,31,248,31,3,31,93,31,255,31,166,31,65,31,164,31,225,31,138,31,237,31,12,31,94,31,251,31,251,30,116,31,116,30,116,29,134,31,21,31,123,31,185,31,185,30,120,31,120,30,54,31,247,31,44,31,26,31,142,31,105,31,118,31,216,31,222,31,180,31,208,31,228,31,161,31,161,30,210,31,49,31,192,31,171,31,30,31,231,31,244,31,244,30,202,31,202,30,255,31,184,31,109,31,114,31,179,31,91,31,94,31,94,30,248,31,248,30,248,29,248,28,226,31,159,31,65,31,4,31,172,31,114,31,195,31,210,31,34,31,34,30,243,31,28,31,241,31,75,31,81,31,63,31,152,31,85,31,217,31,165,31,179,31,231,31,135,31,207,31,148,31,174,31,174,30,47,31,89,31,149,31,98,31,21,31,245,31,30,31,158,31,158,30,23,31,29,31,251,31,56,31,135,31,199,31,199,30,20,31,84,31,222,31,149,31,53,31);

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

-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_485 is
end project_tb_485;

architecture project_tb_arch_485 of project_tb_485 is
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

constant SCENARIO_LENGTH : integer := 608;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (144,0,76,0,0,0,224,0,20,0,234,0,244,0,27,0,225,0,41,0,201,0,124,0,0,0,177,0,135,0,0,0,0,0,0,0,236,0,90,0,171,0,15,0,207,0,45,0,14,0,0,0,137,0,152,0,152,0,178,0,0,0,0,0,250,0,162,0,31,0,14,0,232,0,164,0,179,0,59,0,1,0,254,0,147,0,158,0,188,0,21,0,0,0,118,0,0,0,46,0,119,0,0,0,89,0,0,0,0,0,0,0,98,0,31,0,0,0,101,0,99,0,226,0,107,0,72,0,1,0,31,0,149,0,54,0,6,0,88,0,217,0,0,0,67,0,0,0,155,0,232,0,223,0,51,0,0,0,200,0,175,0,205,0,111,0,0,0,214,0,172,0,0,0,0,0,0,0,166,0,0,0,140,0,0,0,0,0,28,0,236,0,0,0,114,0,101,0,129,0,43,0,37,0,171,0,57,0,167,0,143,0,120,0,44,0,46,0,80,0,217,0,212,0,242,0,0,0,144,0,209,0,120,0,20,0,6,0,0,0,8,0,140,0,163,0,155,0,236,0,61,0,92,0,247,0,131,0,148,0,73,0,209,0,0,0,109,0,99,0,7,0,231,0,155,0,37,0,240,0,0,0,21,0,0,0,175,0,210,0,115,0,0,0,0,0,229,0,8,0,149,0,246,0,156,0,59,0,7,0,218,0,30,0,0,0,94,0,34,0,208,0,254,0,36,0,96,0,220,0,184,0,5,0,58,0,55,0,0,0,129,0,41,0,0,0,168,0,214,0,105,0,164,0,181,0,208,0,131,0,128,0,75,0,103,0,246,0,31,0,228,0,248,0,106,0,0,0,166,0,144,0,181,0,0,0,59,0,248,0,84,0,97,0,19,0,122,0,0,0,115,0,79,0,30,0,184,0,0,0,0,0,0,0,90,0,13,0,0,0,0,0,217,0,212,0,172,0,33,0,67,0,51,0,49,0,178,0,233,0,236,0,238,0,10,0,186,0,128,0,160,0,12,0,0,0,22,0,47,0,182,0,0,0,0,0,230,0,127,0,57,0,8,0,22,0,0,0,160,0,244,0,135,0,126,0,0,0,110,0,178,0,94,0,138,0,83,0,129,0,226,0,22,0,146,0,56,0,12,0,97,0,184,0,244,0,121,0,112,0,0,0,66,0,76,0,26,0,174,0,110,0,98,0,245,0,8,0,156,0,192,0,33,0,198,0,133,0,0,0,29,0,42,0,148,0,36,0,103,0,0,0,228,0,73,0,224,0,191,0,45,0,4,0,103,0,151,0,191,0,0,0,151,0,0,0,37,0,95,0,27,0,219,0,218,0,211,0,0,0,0,0,120,0,128,0,0,0,0,0,28,0,0,0,203,0,211,0,0,0,122,0,67,0,49,0,176,0,199,0,95,0,100,0,160,0,125,0,51,0,247,0,0,0,0,0,0,0,251,0,162,0,252,0,227,0,185,0,107,0,243,0,181,0,17,0,171,0,0,0,0,0,69,0,41,0,225,0,182,0,159,0,56,0,88,0,84,0,207,0,55,0,81,0,46,0,255,0,0,0,162,0,173,0,54,0,131,0,72,0,75,0,157,0,33,0,0,0,94,0,0,0,51,0,24,0,205,0,241,0,9,0,207,0,33,0,231,0,27,0,184,0,8,0,126,0,164,0,234,0,242,0,13,0,178,0,241,0,154,0,238,0,0,0,69,0,227,0,139,0,91,0,80,0,213,0,0,0,22,0,20,0,193,0,187,0,40,0,197,0,202,0,0,0,18,0,199,0,0,0,47,0,0,0,0,0,0,0,6,0,69,0,53,0,78,0,86,0,180,0,166,0,181,0,6,0,100,0,27,0,0,0,182,0,30,0,35,0,86,0,29,0,227,0,0,0,25,0,134,0,218,0,160,0,186,0,224,0,0,0,152,0,0,0,198,0,66,0,237,0,126,0,126,0,143,0,137,0,176,0,160,0,0,0,153,0,136,0,117,0,255,0,39,0,110,0,98,0,0,0,219,0,227,0,109,0,108,0,0,0,0,0,251,0,100,0,0,0,92,0,242,0,153,0,158,0,22,0,120,0,107,0,0,0,255,0,173,0,56,0,168,0,26,0,121,0,203,0,240,0,0,0,10,0,0,0,138,0,0,0,19,0,218,0,141,0,0,0,0,0,207,0,123,0,207,0,35,0,0,0,91,0,0,0,20,0,44,0,211,0,90,0,29,0,38,0,194,0,208,0,42,0,92,0,0,0,134,0,38,0,112,0,135,0,93,0,0,0,179,0,232,0,0,0,0,0,131,0,33,0,255,0,74,0,161,0,174,0,163,0,36,0,100,0,234,0,222,0,191,0,16,0,92,0,39,0,0,0,182,0,68,0,104,0,0,0,47,0,0,0,188,0,120,0,13,0,72,0,190,0,0,0,62,0,0,0,70,0,111,0,32,0,244,0,6,0,142,0,233,0,180,0,116,0,0,0,130,0,0,0,25,0,158,0,16,0,0,0,47,0,40,0,138,0,185,0,103,0,0,0,237,0,82,0,43,0,171,0,161,0,0,0,191,0,12,0,175,0,0,0,143,0,0,0,153,0,0,0,98,0,0,0,0,0,220,0,0,0,217,0,0,0,0,0,143,0,212,0,46,0,126,0,153,0,124,0,0,0,32,0,204,0,208,0,48,0,0,0,7,0,237,0,4,0,0,0,96,0,198,0,116,0,48,0,169,0);
signal scenario_full  : scenario_type := (144,31,76,31,76,30,224,31,20,31,234,31,244,31,27,31,225,31,41,31,201,31,124,31,124,30,177,31,135,31,135,30,135,29,135,28,236,31,90,31,171,31,15,31,207,31,45,31,14,31,14,30,137,31,152,31,152,31,178,31,178,30,178,29,250,31,162,31,31,31,14,31,232,31,164,31,179,31,59,31,1,31,254,31,147,31,158,31,188,31,21,31,21,30,118,31,118,30,46,31,119,31,119,30,89,31,89,30,89,29,89,28,98,31,31,31,31,30,101,31,99,31,226,31,107,31,72,31,1,31,31,31,149,31,54,31,6,31,88,31,217,31,217,30,67,31,67,30,155,31,232,31,223,31,51,31,51,30,200,31,175,31,205,31,111,31,111,30,214,31,172,31,172,30,172,29,172,28,166,31,166,30,140,31,140,30,140,29,28,31,236,31,236,30,114,31,101,31,129,31,43,31,37,31,171,31,57,31,167,31,143,31,120,31,44,31,46,31,80,31,217,31,212,31,242,31,242,30,144,31,209,31,120,31,20,31,6,31,6,30,8,31,140,31,163,31,155,31,236,31,61,31,92,31,247,31,131,31,148,31,73,31,209,31,209,30,109,31,99,31,7,31,231,31,155,31,37,31,240,31,240,30,21,31,21,30,175,31,210,31,115,31,115,30,115,29,229,31,8,31,149,31,246,31,156,31,59,31,7,31,218,31,30,31,30,30,94,31,34,31,208,31,254,31,36,31,96,31,220,31,184,31,5,31,58,31,55,31,55,30,129,31,41,31,41,30,168,31,214,31,105,31,164,31,181,31,208,31,131,31,128,31,75,31,103,31,246,31,31,31,228,31,248,31,106,31,106,30,166,31,144,31,181,31,181,30,59,31,248,31,84,31,97,31,19,31,122,31,122,30,115,31,79,31,30,31,184,31,184,30,184,29,184,28,90,31,13,31,13,30,13,29,217,31,212,31,172,31,33,31,67,31,51,31,49,31,178,31,233,31,236,31,238,31,10,31,186,31,128,31,160,31,12,31,12,30,22,31,47,31,182,31,182,30,182,29,230,31,127,31,57,31,8,31,22,31,22,30,160,31,244,31,135,31,126,31,126,30,110,31,178,31,94,31,138,31,83,31,129,31,226,31,22,31,146,31,56,31,12,31,97,31,184,31,244,31,121,31,112,31,112,30,66,31,76,31,26,31,174,31,110,31,98,31,245,31,8,31,156,31,192,31,33,31,198,31,133,31,133,30,29,31,42,31,148,31,36,31,103,31,103,30,228,31,73,31,224,31,191,31,45,31,4,31,103,31,151,31,191,31,191,30,151,31,151,30,37,31,95,31,27,31,219,31,218,31,211,31,211,30,211,29,120,31,128,31,128,30,128,29,28,31,28,30,203,31,211,31,211,30,122,31,67,31,49,31,176,31,199,31,95,31,100,31,160,31,125,31,51,31,247,31,247,30,247,29,247,28,251,31,162,31,252,31,227,31,185,31,107,31,243,31,181,31,17,31,171,31,171,30,171,29,69,31,41,31,225,31,182,31,159,31,56,31,88,31,84,31,207,31,55,31,81,31,46,31,255,31,255,30,162,31,173,31,54,31,131,31,72,31,75,31,157,31,33,31,33,30,94,31,94,30,51,31,24,31,205,31,241,31,9,31,207,31,33,31,231,31,27,31,184,31,8,31,126,31,164,31,234,31,242,31,13,31,178,31,241,31,154,31,238,31,238,30,69,31,227,31,139,31,91,31,80,31,213,31,213,30,22,31,20,31,193,31,187,31,40,31,197,31,202,31,202,30,18,31,199,31,199,30,47,31,47,30,47,29,47,28,6,31,69,31,53,31,78,31,86,31,180,31,166,31,181,31,6,31,100,31,27,31,27,30,182,31,30,31,35,31,86,31,29,31,227,31,227,30,25,31,134,31,218,31,160,31,186,31,224,31,224,30,152,31,152,30,198,31,66,31,237,31,126,31,126,31,143,31,137,31,176,31,160,31,160,30,153,31,136,31,117,31,255,31,39,31,110,31,98,31,98,30,219,31,227,31,109,31,108,31,108,30,108,29,251,31,100,31,100,30,92,31,242,31,153,31,158,31,22,31,120,31,107,31,107,30,255,31,173,31,56,31,168,31,26,31,121,31,203,31,240,31,240,30,10,31,10,30,138,31,138,30,19,31,218,31,141,31,141,30,141,29,207,31,123,31,207,31,35,31,35,30,91,31,91,30,20,31,44,31,211,31,90,31,29,31,38,31,194,31,208,31,42,31,92,31,92,30,134,31,38,31,112,31,135,31,93,31,93,30,179,31,232,31,232,30,232,29,131,31,33,31,255,31,74,31,161,31,174,31,163,31,36,31,100,31,234,31,222,31,191,31,16,31,92,31,39,31,39,30,182,31,68,31,104,31,104,30,47,31,47,30,188,31,120,31,13,31,72,31,190,31,190,30,62,31,62,30,70,31,111,31,32,31,244,31,6,31,142,31,233,31,180,31,116,31,116,30,130,31,130,30,25,31,158,31,16,31,16,30,47,31,40,31,138,31,185,31,103,31,103,30,237,31,82,31,43,31,171,31,161,31,161,30,191,31,12,31,175,31,175,30,143,31,143,30,153,31,153,30,98,31,98,30,98,29,220,31,220,30,217,31,217,30,217,29,143,31,212,31,46,31,126,31,153,31,124,31,124,30,32,31,204,31,208,31,48,31,48,30,7,31,237,31,4,31,4,30,96,31,198,31,116,31,48,31,169,31);

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

-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_172 is
end project_tb_172;

architecture project_tb_arch_172 of project_tb_172 is
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

constant SCENARIO_LENGTH : integer := 465;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,90,0,0,0,79,0,167,0,0,0,68,0,221,0,76,0,0,0,107,0,189,0,146,0,63,0,35,0,243,0,199,0,129,0,57,0,38,0,31,0,157,0,0,0,16,0,230,0,45,0,41,0,235,0,1,0,217,0,232,0,250,0,49,0,161,0,21,0,224,0,120,0,168,0,221,0,238,0,53,0,156,0,48,0,218,0,147,0,0,0,200,0,163,0,237,0,80,0,0,0,109,0,224,0,144,0,161,0,16,0,194,0,24,0,86,0,106,0,0,0,152,0,77,0,212,0,90,0,190,0,235,0,45,0,255,0,0,0,227,0,248,0,0,0,50,0,143,0,0,0,184,0,9,0,36,0,215,0,61,0,173,0,215,0,187,0,34,0,120,0,159,0,82,0,139,0,244,0,252,0,81,0,9,0,156,0,165,0,49,0,231,0,148,0,15,0,239,0,101,0,0,0,0,0,165,0,230,0,70,0,133,0,63,0,86,0,61,0,164,0,221,0,61,0,96,0,0,0,244,0,178,0,169,0,77,0,54,0,56,0,248,0,232,0,96,0,42,0,28,0,30,0,0,0,146,0,96,0,194,0,87,0,238,0,106,0,137,0,110,0,214,0,90,0,143,0,244,0,70,0,0,0,230,0,186,0,107,0,0,0,0,0,150,0,157,0,245,0,128,0,0,0,248,0,132,0,0,0,0,0,116,0,1,0,0,0,171,0,186,0,197,0,36,0,187,0,0,0,47,0,205,0,0,0,12,0,138,0,205,0,162,0,0,0,161,0,0,0,252,0,167,0,244,0,0,0,145,0,55,0,81,0,115,0,84,0,6,0,251,0,176,0,49,0,99,0,0,0,150,0,231,0,142,0,0,0,27,0,57,0,206,0,41,0,190,0,166,0,0,0,0,0,17,0,185,0,0,0,115,0,0,0,204,0,176,0,205,0,142,0,154,0,0,0,137,0,222,0,231,0,36,0,29,0,7,0,161,0,115,0,226,0,0,0,0,0,252,0,172,0,207,0,131,0,0,0,0,0,7,0,0,0,0,0,152,0,168,0,0,0,246,0,0,0,0,0,177,0,0,0,176,0,122,0,136,0,127,0,243,0,187,0,137,0,0,0,217,0,127,0,188,0,171,0,0,0,146,0,0,0,240,0,14,0,79,0,203,0,78,0,87,0,0,0,51,0,242,0,0,0,0,0,33,0,0,0,161,0,1,0,161,0,162,0,232,0,0,0,158,0,85,0,204,0,48,0,0,0,231,0,59,0,98,0,168,0,34,0,91,0,0,0,173,0,0,0,191,0,0,0,154,0,133,0,169,0,0,0,25,0,0,0,53,0,208,0,60,0,0,0,12,0,37,0,70,0,134,0,239,0,159,0,207,0,251,0,244,0,248,0,168,0,227,0,136,0,102,0,167,0,178,0,200,0,191,0,30,0,0,0,0,0,202,0,50,0,22,0,0,0,120,0,139,0,52,0,75,0,0,0,46,0,0,0,40,0,45,0,102,0,0,0,229,0,185,0,114,0,131,0,141,0,181,0,201,0,225,0,0,0,244,0,238,0,242,0,8,0,76,0,78,0,233,0,15,0,69,0,0,0,193,0,0,0,27,0,0,0,115,0,2,0,195,0,0,0,91,0,11,0,0,0,210,0,198,0,82,0,191,0,255,0,254,0,151,0,223,0,0,0,1,0,0,0,233,0,86,0,48,0,0,0,196,0,245,0,44,0,60,0,49,0,233,0,105,0,38,0,39,0,152,0,51,0,0,0,177,0,35,0,209,0,200,0,213,0,13,0,94,0,245,0,2,0,16,0,126,0,49,0,166,0,217,0,210,0,159,0,0,0,0,0,240,0,0,0,112,0,86,0,0,0,227,0,84,0,0,0,135,0,58,0,233,0,138,0,187,0,150,0,0,0,2,0,24,0,179,0,149,0,66,0,0,0,210,0,194,0,23,0,86,0,173,0,60,0,78,0,0,0,50,0,19,0,0,0,147,0,47,0,85,0,117,0,90,0,251,0,0,0,227,0,17,0,63,0,8,0,7,0,3,0,99,0,124,0,238,0,97,0,40,0,135,0,0,0,94,0);
signal scenario_full  : scenario_type := (0,0,90,31,90,30,79,31,167,31,167,30,68,31,221,31,76,31,76,30,107,31,189,31,146,31,63,31,35,31,243,31,199,31,129,31,57,31,38,31,31,31,157,31,157,30,16,31,230,31,45,31,41,31,235,31,1,31,217,31,232,31,250,31,49,31,161,31,21,31,224,31,120,31,168,31,221,31,238,31,53,31,156,31,48,31,218,31,147,31,147,30,200,31,163,31,237,31,80,31,80,30,109,31,224,31,144,31,161,31,16,31,194,31,24,31,86,31,106,31,106,30,152,31,77,31,212,31,90,31,190,31,235,31,45,31,255,31,255,30,227,31,248,31,248,30,50,31,143,31,143,30,184,31,9,31,36,31,215,31,61,31,173,31,215,31,187,31,34,31,120,31,159,31,82,31,139,31,244,31,252,31,81,31,9,31,156,31,165,31,49,31,231,31,148,31,15,31,239,31,101,31,101,30,101,29,165,31,230,31,70,31,133,31,63,31,86,31,61,31,164,31,221,31,61,31,96,31,96,30,244,31,178,31,169,31,77,31,54,31,56,31,248,31,232,31,96,31,42,31,28,31,30,31,30,30,146,31,96,31,194,31,87,31,238,31,106,31,137,31,110,31,214,31,90,31,143,31,244,31,70,31,70,30,230,31,186,31,107,31,107,30,107,29,150,31,157,31,245,31,128,31,128,30,248,31,132,31,132,30,132,29,116,31,1,31,1,30,171,31,186,31,197,31,36,31,187,31,187,30,47,31,205,31,205,30,12,31,138,31,205,31,162,31,162,30,161,31,161,30,252,31,167,31,244,31,244,30,145,31,55,31,81,31,115,31,84,31,6,31,251,31,176,31,49,31,99,31,99,30,150,31,231,31,142,31,142,30,27,31,57,31,206,31,41,31,190,31,166,31,166,30,166,29,17,31,185,31,185,30,115,31,115,30,204,31,176,31,205,31,142,31,154,31,154,30,137,31,222,31,231,31,36,31,29,31,7,31,161,31,115,31,226,31,226,30,226,29,252,31,172,31,207,31,131,31,131,30,131,29,7,31,7,30,7,29,152,31,168,31,168,30,246,31,246,30,246,29,177,31,177,30,176,31,122,31,136,31,127,31,243,31,187,31,137,31,137,30,217,31,127,31,188,31,171,31,171,30,146,31,146,30,240,31,14,31,79,31,203,31,78,31,87,31,87,30,51,31,242,31,242,30,242,29,33,31,33,30,161,31,1,31,161,31,162,31,232,31,232,30,158,31,85,31,204,31,48,31,48,30,231,31,59,31,98,31,168,31,34,31,91,31,91,30,173,31,173,30,191,31,191,30,154,31,133,31,169,31,169,30,25,31,25,30,53,31,208,31,60,31,60,30,12,31,37,31,70,31,134,31,239,31,159,31,207,31,251,31,244,31,248,31,168,31,227,31,136,31,102,31,167,31,178,31,200,31,191,31,30,31,30,30,30,29,202,31,50,31,22,31,22,30,120,31,139,31,52,31,75,31,75,30,46,31,46,30,40,31,45,31,102,31,102,30,229,31,185,31,114,31,131,31,141,31,181,31,201,31,225,31,225,30,244,31,238,31,242,31,8,31,76,31,78,31,233,31,15,31,69,31,69,30,193,31,193,30,27,31,27,30,115,31,2,31,195,31,195,30,91,31,11,31,11,30,210,31,198,31,82,31,191,31,255,31,254,31,151,31,223,31,223,30,1,31,1,30,233,31,86,31,48,31,48,30,196,31,245,31,44,31,60,31,49,31,233,31,105,31,38,31,39,31,152,31,51,31,51,30,177,31,35,31,209,31,200,31,213,31,13,31,94,31,245,31,2,31,16,31,126,31,49,31,166,31,217,31,210,31,159,31,159,30,159,29,240,31,240,30,112,31,86,31,86,30,227,31,84,31,84,30,135,31,58,31,233,31,138,31,187,31,150,31,150,30,2,31,24,31,179,31,149,31,66,31,66,30,210,31,194,31,23,31,86,31,173,31,60,31,78,31,78,30,50,31,19,31,19,30,147,31,47,31,85,31,117,31,90,31,251,31,251,30,227,31,17,31,63,31,8,31,7,31,3,31,99,31,124,31,238,31,97,31,40,31,135,31,135,30,94,31);

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

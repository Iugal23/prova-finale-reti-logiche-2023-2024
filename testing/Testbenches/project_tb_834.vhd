-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_834 is
end project_tb_834;

architecture project_tb_arch_834 of project_tb_834 is
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

constant SCENARIO_LENGTH : integer := 665;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (5,0,146,0,204,0,45,0,9,0,42,0,16,0,241,0,71,0,0,0,26,0,242,0,184,0,102,0,139,0,21,0,0,0,114,0,0,0,0,0,66,0,151,0,239,0,0,0,205,0,64,0,141,0,200,0,58,0,181,0,217,0,236,0,104,0,148,0,158,0,0,0,59,0,10,0,105,0,0,0,0,0,147,0,170,0,255,0,82,0,33,0,77,0,134,0,225,0,208,0,0,0,209,0,219,0,106,0,255,0,0,0,224,0,142,0,181,0,0,0,59,0,27,0,120,0,55,0,8,0,91,0,133,0,119,0,182,0,0,0,117,0,91,0,179,0,193,0,84,0,105,0,0,0,85,0,49,0,235,0,0,0,89,0,37,0,12,0,179,0,246,0,0,0,8,0,72,0,220,0,224,0,0,0,95,0,74,0,9,0,32,0,0,0,185,0,0,0,0,0,253,0,0,0,80,0,177,0,175,0,174,0,231,0,0,0,0,0,7,0,0,0,0,0,14,0,0,0,71,0,96,0,116,0,0,0,169,0,93,0,194,0,0,0,0,0,49,0,169,0,251,0,0,0,190,0,243,0,240,0,0,0,152,0,0,0,235,0,75,0,214,0,244,0,69,0,63,0,222,0,14,0,0,0,14,0,11,0,111,0,0,0,25,0,155,0,84,0,73,0,75,0,68,0,91,0,168,0,240,0,178,0,0,0,161,0,88,0,75,0,0,0,44,0,0,0,0,0,72,0,91,0,207,0,0,0,153,0,63,0,193,0,69,0,150,0,61,0,136,0,0,0,109,0,0,0,0,0,0,0,75,0,99,0,106,0,224,0,216,0,0,0,51,0,231,0,133,0,243,0,180,0,115,0,93,0,0,0,127,0,206,0,138,0,195,0,59,0,144,0,178,0,8,0,0,0,63,0,0,0,0,0,53,0,0,0,149,0,3,0,147,0,0,0,197,0,222,0,45,0,206,0,74,0,80,0,0,0,87,0,145,0,90,0,137,0,175,0,0,0,41,0,212,0,0,0,0,0,14,0,0,0,129,0,0,0,3,0,0,0,166,0,208,0,113,0,43,0,209,0,0,0,21,0,225,0,80,0,0,0,162,0,140,0,211,0,34,0,232,0,148,0,205,0,140,0,227,0,0,0,0,0,167,0,0,0,167,0,228,0,164,0,234,0,0,0,0,0,43,0,31,0,244,0,0,0,191,0,27,0,186,0,139,0,79,0,236,0,0,0,33,0,59,0,0,0,160,0,50,0,154,0,3,0,182,0,127,0,68,0,0,0,149,0,47,0,0,0,0,0,0,0,0,0,202,0,3,0,134,0,246,0,169,0,226,0,133,0,124,0,150,0,0,0,204,0,177,0,108,0,0,0,84,0,176,0,109,0,131,0,202,0,55,0,123,0,245,0,109,0,125,0,205,0,187,0,63,0,5,0,163,0,87,0,143,0,80,0,139,0,0,0,48,0,195,0,123,0,0,0,184,0,195,0,0,0,134,0,217,0,158,0,48,0,7,0,0,0,93,0,157,0,159,0,184,0,148,0,0,0,113,0,55,0,97,0,129,0,24,0,90,0,88,0,142,0,105,0,151,0,115,0,0,0,0,0,0,0,30,0,116,0,240,0,0,0,162,0,165,0,9,0,33,0,15,0,84,0,155,0,0,0,0,0,155,0,75,0,145,0,10,0,229,0,135,0,61,0,37,0,0,0,35,0,144,0,0,0,63,0,27,0,112,0,243,0,214,0,0,0,0,0,204,0,18,0,193,0,16,0,0,0,64,0,152,0,0,0,214,0,0,0,0,0,51,0,127,0,0,0,5,0,107,0,63,0,61,0,32,0,47,0,98,0,0,0,0,0,199,0,34,0,84,0,168,0,126,0,0,0,165,0,101,0,222,0,14,0,49,0,144,0,0,0,138,0,94,0,237,0,82,0,28,0,105,0,7,0,17,0,201,0,70,0,150,0,99,0,67,0,75,0,168,0,220,0,227,0,4,0,203,0,99,0,0,0,218,0,44,0,39,0,53,0,0,0,0,0,0,0,0,0,200,0,78,0,186,0,253,0,3,0,0,0,246,0,0,0,21,0,76,0,0,0,73,0,0,0,0,0,109,0,157,0,141,0,0,0,166,0,76,0,143,0,245,0,3,0,0,0,233,0,0,0,253,0,0,0,176,0,130,0,115,0,2,0,192,0,131,0,139,0,205,0,250,0,0,0,186,0,229,0,13,0,217,0,115,0,26,0,212,0,28,0,2,0,187,0,45,0,153,0,135,0,0,0,14,0,0,0,65,0,0,0,141,0,0,0,63,0,133,0,0,0,59,0,1,0,71,0,155,0,169,0,179,0,196,0,252,0,151,0,83,0,147,0,172,0,186,0,130,0,63,0,62,0,0,0,48,0,0,0,99,0,0,0,147,0,177,0,0,0,122,0,0,0,226,0,15,0,75,0,0,0,113,0,186,0,128,0,18,0,19,0,166,0,15,0,83,0,159,0,0,0,198,0,240,0,134,0,12,0,0,0,11,0,67,0,208,0,212,0,0,0,133,0,0,0,255,0,213,0,10,0,90,0,90,0,0,0,157,0,248,0,72,0,229,0,251,0,0,0,0,0,193,0,140,0,160,0,134,0,203,0,0,0,55,0,56,0,38,0,54,0,186,0,253,0,209,0,153,0,47,0,57,0,43,0,0,0,0,0,103,0,201,0,87,0,40,0,0,0,110,0,250,0,50,0,49,0,56,0,30,0,8,0,254,0,35,0,91,0,154,0,137,0,0,0,181,0,245,0,166,0,34,0,223,0,0,0,231,0,8,0,38,0,112,0,232,0,135,0,30,0,0,0,29,0,18,0,62,0,234,0,0,0,59,0,76,0,185,0,30,0,35,0,62,0,16,0,167,0,127,0,73,0,232,0,122,0,0,0,87,0,168,0,248,0,80,0,192,0,166,0,235,0,8,0,0,0,78,0,44,0,203,0,0,0,135,0);
signal scenario_full  : scenario_type := (5,31,146,31,204,31,45,31,9,31,42,31,16,31,241,31,71,31,71,30,26,31,242,31,184,31,102,31,139,31,21,31,21,30,114,31,114,30,114,29,66,31,151,31,239,31,239,30,205,31,64,31,141,31,200,31,58,31,181,31,217,31,236,31,104,31,148,31,158,31,158,30,59,31,10,31,105,31,105,30,105,29,147,31,170,31,255,31,82,31,33,31,77,31,134,31,225,31,208,31,208,30,209,31,219,31,106,31,255,31,255,30,224,31,142,31,181,31,181,30,59,31,27,31,120,31,55,31,8,31,91,31,133,31,119,31,182,31,182,30,117,31,91,31,179,31,193,31,84,31,105,31,105,30,85,31,49,31,235,31,235,30,89,31,37,31,12,31,179,31,246,31,246,30,8,31,72,31,220,31,224,31,224,30,95,31,74,31,9,31,32,31,32,30,185,31,185,30,185,29,253,31,253,30,80,31,177,31,175,31,174,31,231,31,231,30,231,29,7,31,7,30,7,29,14,31,14,30,71,31,96,31,116,31,116,30,169,31,93,31,194,31,194,30,194,29,49,31,169,31,251,31,251,30,190,31,243,31,240,31,240,30,152,31,152,30,235,31,75,31,214,31,244,31,69,31,63,31,222,31,14,31,14,30,14,31,11,31,111,31,111,30,25,31,155,31,84,31,73,31,75,31,68,31,91,31,168,31,240,31,178,31,178,30,161,31,88,31,75,31,75,30,44,31,44,30,44,29,72,31,91,31,207,31,207,30,153,31,63,31,193,31,69,31,150,31,61,31,136,31,136,30,109,31,109,30,109,29,109,28,75,31,99,31,106,31,224,31,216,31,216,30,51,31,231,31,133,31,243,31,180,31,115,31,93,31,93,30,127,31,206,31,138,31,195,31,59,31,144,31,178,31,8,31,8,30,63,31,63,30,63,29,53,31,53,30,149,31,3,31,147,31,147,30,197,31,222,31,45,31,206,31,74,31,80,31,80,30,87,31,145,31,90,31,137,31,175,31,175,30,41,31,212,31,212,30,212,29,14,31,14,30,129,31,129,30,3,31,3,30,166,31,208,31,113,31,43,31,209,31,209,30,21,31,225,31,80,31,80,30,162,31,140,31,211,31,34,31,232,31,148,31,205,31,140,31,227,31,227,30,227,29,167,31,167,30,167,31,228,31,164,31,234,31,234,30,234,29,43,31,31,31,244,31,244,30,191,31,27,31,186,31,139,31,79,31,236,31,236,30,33,31,59,31,59,30,160,31,50,31,154,31,3,31,182,31,127,31,68,31,68,30,149,31,47,31,47,30,47,29,47,28,47,27,202,31,3,31,134,31,246,31,169,31,226,31,133,31,124,31,150,31,150,30,204,31,177,31,108,31,108,30,84,31,176,31,109,31,131,31,202,31,55,31,123,31,245,31,109,31,125,31,205,31,187,31,63,31,5,31,163,31,87,31,143,31,80,31,139,31,139,30,48,31,195,31,123,31,123,30,184,31,195,31,195,30,134,31,217,31,158,31,48,31,7,31,7,30,93,31,157,31,159,31,184,31,148,31,148,30,113,31,55,31,97,31,129,31,24,31,90,31,88,31,142,31,105,31,151,31,115,31,115,30,115,29,115,28,30,31,116,31,240,31,240,30,162,31,165,31,9,31,33,31,15,31,84,31,155,31,155,30,155,29,155,31,75,31,145,31,10,31,229,31,135,31,61,31,37,31,37,30,35,31,144,31,144,30,63,31,27,31,112,31,243,31,214,31,214,30,214,29,204,31,18,31,193,31,16,31,16,30,64,31,152,31,152,30,214,31,214,30,214,29,51,31,127,31,127,30,5,31,107,31,63,31,61,31,32,31,47,31,98,31,98,30,98,29,199,31,34,31,84,31,168,31,126,31,126,30,165,31,101,31,222,31,14,31,49,31,144,31,144,30,138,31,94,31,237,31,82,31,28,31,105,31,7,31,17,31,201,31,70,31,150,31,99,31,67,31,75,31,168,31,220,31,227,31,4,31,203,31,99,31,99,30,218,31,44,31,39,31,53,31,53,30,53,29,53,28,53,27,200,31,78,31,186,31,253,31,3,31,3,30,246,31,246,30,21,31,76,31,76,30,73,31,73,30,73,29,109,31,157,31,141,31,141,30,166,31,76,31,143,31,245,31,3,31,3,30,233,31,233,30,253,31,253,30,176,31,130,31,115,31,2,31,192,31,131,31,139,31,205,31,250,31,250,30,186,31,229,31,13,31,217,31,115,31,26,31,212,31,28,31,2,31,187,31,45,31,153,31,135,31,135,30,14,31,14,30,65,31,65,30,141,31,141,30,63,31,133,31,133,30,59,31,1,31,71,31,155,31,169,31,179,31,196,31,252,31,151,31,83,31,147,31,172,31,186,31,130,31,63,31,62,31,62,30,48,31,48,30,99,31,99,30,147,31,177,31,177,30,122,31,122,30,226,31,15,31,75,31,75,30,113,31,186,31,128,31,18,31,19,31,166,31,15,31,83,31,159,31,159,30,198,31,240,31,134,31,12,31,12,30,11,31,67,31,208,31,212,31,212,30,133,31,133,30,255,31,213,31,10,31,90,31,90,31,90,30,157,31,248,31,72,31,229,31,251,31,251,30,251,29,193,31,140,31,160,31,134,31,203,31,203,30,55,31,56,31,38,31,54,31,186,31,253,31,209,31,153,31,47,31,57,31,43,31,43,30,43,29,103,31,201,31,87,31,40,31,40,30,110,31,250,31,50,31,49,31,56,31,30,31,8,31,254,31,35,31,91,31,154,31,137,31,137,30,181,31,245,31,166,31,34,31,223,31,223,30,231,31,8,31,38,31,112,31,232,31,135,31,30,31,30,30,29,31,18,31,62,31,234,31,234,30,59,31,76,31,185,31,30,31,35,31,62,31,16,31,167,31,127,31,73,31,232,31,122,31,122,30,87,31,168,31,248,31,80,31,192,31,166,31,235,31,8,31,8,30,78,31,44,31,203,31,203,30,135,31);

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

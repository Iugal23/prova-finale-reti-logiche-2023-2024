-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_188 is
end project_tb_188;

architecture project_tb_arch_188 of project_tb_188 is
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

constant SCENARIO_LENGTH : integer := 368;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,89,0,174,0,0,0,0,0,0,0,12,0,133,0,240,0,199,0,78,0,75,0,227,0,239,0,156,0,163,0,0,0,148,0,239,0,194,0,134,0,165,0,89,0,209,0,236,0,247,0,0,0,0,0,222,0,27,0,0,0,83,0,81,0,0,0,192,0,218,0,35,0,255,0,251,0,202,0,30,0,239,0,41,0,59,0,99,0,114,0,150,0,155,0,111,0,149,0,197,0,185,0,87,0,124,0,201,0,246,0,0,0,217,0,220,0,134,0,14,0,114,0,130,0,0,0,29,0,115,0,134,0,0,0,48,0,140,0,252,0,79,0,0,0,121,0,76,0,0,0,194,0,253,0,200,0,108,0,1,0,208,0,15,0,0,0,166,0,34,0,23,0,122,0,179,0,63,0,0,0,94,0,165,0,44,0,37,0,21,0,110,0,2,0,3,0,0,0,255,0,237,0,82,0,101,0,114,0,82,0,113,0,197,0,62,0,145,0,214,0,81,0,112,0,205,0,0,0,217,0,44,0,223,0,175,0,110,0,204,0,18,0,234,0,40,0,151,0,168,0,10,0,0,0,0,0,74,0,5,0,133,0,146,0,174,0,0,0,129,0,32,0,169,0,41,0,0,0,0,0,100,0,56,0,52,0,40,0,200,0,63,0,80,0,5,0,206,0,60,0,0,0,88,0,0,0,0,0,0,0,127,0,0,0,0,0,197,0,164,0,111,0,221,0,0,0,10,0,92,0,149,0,37,0,0,0,0,0,123,0,0,0,161,0,251,0,203,0,208,0,154,0,73,0,0,0,101,0,0,0,42,0,159,0,123,0,0,0,115,0,5,0,57,0,144,0,12,0,75,0,69,0,33,0,118,0,27,0,139,0,56,0,0,0,16,0,0,0,247,0,0,0,246,0,31,0,55,0,107,0,0,0,122,0,104,0,185,0,198,0,255,0,53,0,81,0,223,0,110,0,0,0,0,0,161,0,81,0,0,0,0,0,3,0,66,0,0,0,134,0,18,0,0,0,0,0,95,0,191,0,253,0,5,0,228,0,192,0,213,0,0,0,0,0,0,0,0,0,222,0,39,0,19,0,98,0,4,0,0,0,40,0,190,0,108,0,122,0,128,0,50,0,189,0,105,0,187,0,237,0,214,0,247,0,236,0,0,0,212,0,228,0,90,0,209,0,91,0,184,0,75,0,218,0,20,0,65,0,105,0,14,0,226,0,78,0,149,0,152,0,0,0,28,0,201,0,54,0,176,0,77,0,80,0,54,0,21,0,7,0,15,0,0,0,225,0,109,0,0,0,0,0,142,0,0,0,182,0,190,0,45,0,75,0,205,0,187,0,162,0,191,0,108,0,0,0,105,0,26,0,187,0,104,0,166,0,228,0,97,0,21,0,106,0,42,0,163,0,79,0,67,0,17,0,96,0,238,0,48,0,59,0,121,0,126,0,113,0,117,0,16,0,242,0,93,0,120,0,38,0,203,0,246,0,220,0,227,0,234,0,42,0,0,0,0,0,199,0,124,0,51,0,80,0,163,0,5,0,95,0,78,0,92,0,44,0,184,0,157,0,0,0,12,0,189,0,0,0,0,0,150,0,0,0,195,0,34,0,255,0,144,0,208,0,147,0,105,0,159,0,15,0,199,0);
signal scenario_full  : scenario_type := (0,0,89,31,174,31,174,30,174,29,174,28,12,31,133,31,240,31,199,31,78,31,75,31,227,31,239,31,156,31,163,31,163,30,148,31,239,31,194,31,134,31,165,31,89,31,209,31,236,31,247,31,247,30,247,29,222,31,27,31,27,30,83,31,81,31,81,30,192,31,218,31,35,31,255,31,251,31,202,31,30,31,239,31,41,31,59,31,99,31,114,31,150,31,155,31,111,31,149,31,197,31,185,31,87,31,124,31,201,31,246,31,246,30,217,31,220,31,134,31,14,31,114,31,130,31,130,30,29,31,115,31,134,31,134,30,48,31,140,31,252,31,79,31,79,30,121,31,76,31,76,30,194,31,253,31,200,31,108,31,1,31,208,31,15,31,15,30,166,31,34,31,23,31,122,31,179,31,63,31,63,30,94,31,165,31,44,31,37,31,21,31,110,31,2,31,3,31,3,30,255,31,237,31,82,31,101,31,114,31,82,31,113,31,197,31,62,31,145,31,214,31,81,31,112,31,205,31,205,30,217,31,44,31,223,31,175,31,110,31,204,31,18,31,234,31,40,31,151,31,168,31,10,31,10,30,10,29,74,31,5,31,133,31,146,31,174,31,174,30,129,31,32,31,169,31,41,31,41,30,41,29,100,31,56,31,52,31,40,31,200,31,63,31,80,31,5,31,206,31,60,31,60,30,88,31,88,30,88,29,88,28,127,31,127,30,127,29,197,31,164,31,111,31,221,31,221,30,10,31,92,31,149,31,37,31,37,30,37,29,123,31,123,30,161,31,251,31,203,31,208,31,154,31,73,31,73,30,101,31,101,30,42,31,159,31,123,31,123,30,115,31,5,31,57,31,144,31,12,31,75,31,69,31,33,31,118,31,27,31,139,31,56,31,56,30,16,31,16,30,247,31,247,30,246,31,31,31,55,31,107,31,107,30,122,31,104,31,185,31,198,31,255,31,53,31,81,31,223,31,110,31,110,30,110,29,161,31,81,31,81,30,81,29,3,31,66,31,66,30,134,31,18,31,18,30,18,29,95,31,191,31,253,31,5,31,228,31,192,31,213,31,213,30,213,29,213,28,213,27,222,31,39,31,19,31,98,31,4,31,4,30,40,31,190,31,108,31,122,31,128,31,50,31,189,31,105,31,187,31,237,31,214,31,247,31,236,31,236,30,212,31,228,31,90,31,209,31,91,31,184,31,75,31,218,31,20,31,65,31,105,31,14,31,226,31,78,31,149,31,152,31,152,30,28,31,201,31,54,31,176,31,77,31,80,31,54,31,21,31,7,31,15,31,15,30,225,31,109,31,109,30,109,29,142,31,142,30,182,31,190,31,45,31,75,31,205,31,187,31,162,31,191,31,108,31,108,30,105,31,26,31,187,31,104,31,166,31,228,31,97,31,21,31,106,31,42,31,163,31,79,31,67,31,17,31,96,31,238,31,48,31,59,31,121,31,126,31,113,31,117,31,16,31,242,31,93,31,120,31,38,31,203,31,246,31,220,31,227,31,234,31,42,31,42,30,42,29,199,31,124,31,51,31,80,31,163,31,5,31,95,31,78,31,92,31,44,31,184,31,157,31,157,30,12,31,189,31,189,30,189,29,150,31,150,30,195,31,34,31,255,31,144,31,208,31,147,31,105,31,159,31,15,31,199,31);

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

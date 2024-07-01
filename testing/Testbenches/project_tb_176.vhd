-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_176 is
end project_tb_176;

architecture project_tb_arch_176 of project_tb_176 is
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

constant SCENARIO_LENGTH : integer := 384;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (181,0,0,0,0,0,144,0,188,0,129,0,75,0,0,0,0,0,0,0,154,0,13,0,137,0,157,0,182,0,40,0,0,0,64,0,0,0,195,0,123,0,172,0,210,0,211,0,161,0,39,0,179,0,241,0,0,0,20,0,214,0,166,0,102,0,145,0,18,0,230,0,17,0,38,0,65,0,86,0,255,0,122,0,86,0,191,0,0,0,0,0,170,0,93,0,113,0,207,0,21,0,198,0,0,0,45,0,221,0,237,0,218,0,225,0,219,0,121,0,0,0,187,0,46,0,0,0,54,0,0,0,0,0,117,0,12,0,0,0,220,0,186,0,174,0,1,0,1,0,0,0,135,0,9,0,129,0,0,0,200,0,159,0,0,0,203,0,25,0,228,0,49,0,178,0,0,0,174,0,24,0,17,0,81,0,32,0,152,0,88,0,0,0,113,0,154,0,0,0,74,0,247,0,246,0,74,0,0,0,81,0,37,0,28,0,251,0,0,0,178,0,196,0,0,0,248,0,255,0,87,0,219,0,241,0,18,0,0,0,176,0,15,0,156,0,0,0,81,0,210,0,207,0,192,0,209,0,188,0,108,0,234,0,142,0,156,0,0,0,204,0,186,0,207,0,87,0,0,0,112,0,29,0,8,0,103,0,140,0,151,0,152,0,39,0,192,0,143,0,193,0,185,0,106,0,205,0,6,0,0,0,164,0,0,0,181,0,69,0,15,0,0,0,228,0,135,0,254,0,91,0,0,0,124,0,159,0,133,0,57,0,68,0,0,0,195,0,73,0,0,0,2,0,232,0,31,0,166,0,0,0,222,0,74,0,99,0,40,0,73,0,19,0,93,0,154,0,58,0,102,0,82,0,5,0,0,0,228,0,0,0,0,0,0,0,111,0,44,0,129,0,40,0,223,0,156,0,187,0,167,0,114,0,0,0,0,0,181,0,82,0,13,0,2,0,28,0,106,0,0,0,0,0,32,0,125,0,60,0,243,0,150,0,38,0,38,0,236,0,0,0,0,0,68,0,204,0,4,0,141,0,203,0,148,0,31,0,50,0,233,0,145,0,41,0,0,0,0,0,69,0,15,0,183,0,180,0,9,0,26,0,184,0,0,0,0,0,59,0,178,0,184,0,94,0,18,0,45,0,183,0,66,0,36,0,35,0,214,0,29,0,186,0,128,0,0,0,29,0,52,0,0,0,40,0,0,0,43,0,193,0,123,0,128,0,0,0,245,0,129,0,0,0,0,0,15,0,40,0,101,0,2,0,0,0,152,0,0,0,130,0,0,0,0,0,176,0,165,0,0,0,207,0,0,0,17,0,0,0,77,0,0,0,59,0,230,0,135,0,0,0,0,0,111,0,0,0,114,0,0,0,58,0,2,0,211,0,105,0,50,0,169,0,0,0,0,0,18,0,200,0,50,0,0,0,120,0,73,0,175,0,30,0,0,0,174,0,230,0,209,0,0,0,142,0,188,0,170,0,204,0,131,0,68,0,17,0,90,0,0,0,97,0,0,0,237,0,41,0,49,0,0,0,143,0,230,0,27,0,23,0,77,0,165,0,229,0,158,0,147,0,40,0,0,0,154,0,189,0,48,0,4,0,49,0,86,0,6,0,0,0,97,0,190,0,0,0,0,0,68,0,74,0,103,0,237,0,232,0,245,0,23,0,0,0,240,0,0,0,0,0,0,0,0,0,163,0,243,0,69,0,241,0,220,0,178,0);
signal scenario_full  : scenario_type := (181,31,181,30,181,29,144,31,188,31,129,31,75,31,75,30,75,29,75,28,154,31,13,31,137,31,157,31,182,31,40,31,40,30,64,31,64,30,195,31,123,31,172,31,210,31,211,31,161,31,39,31,179,31,241,31,241,30,20,31,214,31,166,31,102,31,145,31,18,31,230,31,17,31,38,31,65,31,86,31,255,31,122,31,86,31,191,31,191,30,191,29,170,31,93,31,113,31,207,31,21,31,198,31,198,30,45,31,221,31,237,31,218,31,225,31,219,31,121,31,121,30,187,31,46,31,46,30,54,31,54,30,54,29,117,31,12,31,12,30,220,31,186,31,174,31,1,31,1,31,1,30,135,31,9,31,129,31,129,30,200,31,159,31,159,30,203,31,25,31,228,31,49,31,178,31,178,30,174,31,24,31,17,31,81,31,32,31,152,31,88,31,88,30,113,31,154,31,154,30,74,31,247,31,246,31,74,31,74,30,81,31,37,31,28,31,251,31,251,30,178,31,196,31,196,30,248,31,255,31,87,31,219,31,241,31,18,31,18,30,176,31,15,31,156,31,156,30,81,31,210,31,207,31,192,31,209,31,188,31,108,31,234,31,142,31,156,31,156,30,204,31,186,31,207,31,87,31,87,30,112,31,29,31,8,31,103,31,140,31,151,31,152,31,39,31,192,31,143,31,193,31,185,31,106,31,205,31,6,31,6,30,164,31,164,30,181,31,69,31,15,31,15,30,228,31,135,31,254,31,91,31,91,30,124,31,159,31,133,31,57,31,68,31,68,30,195,31,73,31,73,30,2,31,232,31,31,31,166,31,166,30,222,31,74,31,99,31,40,31,73,31,19,31,93,31,154,31,58,31,102,31,82,31,5,31,5,30,228,31,228,30,228,29,228,28,111,31,44,31,129,31,40,31,223,31,156,31,187,31,167,31,114,31,114,30,114,29,181,31,82,31,13,31,2,31,28,31,106,31,106,30,106,29,32,31,125,31,60,31,243,31,150,31,38,31,38,31,236,31,236,30,236,29,68,31,204,31,4,31,141,31,203,31,148,31,31,31,50,31,233,31,145,31,41,31,41,30,41,29,69,31,15,31,183,31,180,31,9,31,26,31,184,31,184,30,184,29,59,31,178,31,184,31,94,31,18,31,45,31,183,31,66,31,36,31,35,31,214,31,29,31,186,31,128,31,128,30,29,31,52,31,52,30,40,31,40,30,43,31,193,31,123,31,128,31,128,30,245,31,129,31,129,30,129,29,15,31,40,31,101,31,2,31,2,30,152,31,152,30,130,31,130,30,130,29,176,31,165,31,165,30,207,31,207,30,17,31,17,30,77,31,77,30,59,31,230,31,135,31,135,30,135,29,111,31,111,30,114,31,114,30,58,31,2,31,211,31,105,31,50,31,169,31,169,30,169,29,18,31,200,31,50,31,50,30,120,31,73,31,175,31,30,31,30,30,174,31,230,31,209,31,209,30,142,31,188,31,170,31,204,31,131,31,68,31,17,31,90,31,90,30,97,31,97,30,237,31,41,31,49,31,49,30,143,31,230,31,27,31,23,31,77,31,165,31,229,31,158,31,147,31,40,31,40,30,154,31,189,31,48,31,4,31,49,31,86,31,6,31,6,30,97,31,190,31,190,30,190,29,68,31,74,31,103,31,237,31,232,31,245,31,23,31,23,30,240,31,240,30,240,29,240,28,240,27,163,31,243,31,69,31,241,31,220,31,178,31);

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

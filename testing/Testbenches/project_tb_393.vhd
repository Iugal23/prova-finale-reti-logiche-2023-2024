-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_393 is
end project_tb_393;

architecture project_tb_arch_393 of project_tb_393 is
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

constant SCENARIO_LENGTH : integer := 247;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (200,0,32,0,217,0,204,0,141,0,0,0,0,0,32,0,74,0,85,0,184,0,0,0,121,0,91,0,132,0,165,0,0,0,0,0,208,0,238,0,0,0,172,0,195,0,30,0,38,0,0,0,203,0,0,0,146,0,147,0,175,0,115,0,185,0,136,0,195,0,194,0,24,0,226,0,173,0,0,0,0,0,198,0,0,0,68,0,100,0,170,0,0,0,31,0,0,0,168,0,214,0,158,0,54,0,136,0,0,0,203,0,179,0,0,0,185,0,13,0,63,0,173,0,0,0,238,0,170,0,210,0,251,0,22,0,0,0,4,0,0,0,0,0,128,0,230,0,106,0,151,0,225,0,187,0,234,0,0,0,77,0,235,0,123,0,12,0,18,0,0,0,0,0,217,0,0,0,226,0,0,0,38,0,0,0,103,0,155,0,152,0,95,0,0,0,0,0,192,0,15,0,0,0,2,0,92,0,230,0,153,0,251,0,129,0,0,0,0,0,119,0,71,0,151,0,40,0,195,0,51,0,163,0,248,0,88,0,0,0,105,0,7,0,79,0,168,0,123,0,198,0,0,0,51,0,0,0,146,0,7,0,209,0,0,0,123,0,33,0,185,0,188,0,0,0,197,0,158,0,18,0,205,0,37,0,69,0,175,0,119,0,0,0,174,0,30,0,107,0,160,0,107,0,1,0,0,0,0,0,142,0,126,0,61,0,21,0,247,0,0,0,162,0,0,0,169,0,0,0,81,0,44,0,65,0,110,0,247,0,0,0,74,0,14,0,125,0,4,0,46,0,122,0,102,0,180,0,94,0,127,0,247,0,0,0,220,0,148,0,4,0,50,0,229,0,146,0,48,0,0,0,23,0,0,0,240,0,215,0,184,0,0,0,236,0,105,0,227,0,164,0,142,0,251,0,185,0,127,0,49,0,147,0,0,0,116,0,6,0,87,0,100,0,187,0,4,0,0,0,120,0,0,0,0,0,20,0,34,0,159,0,0,0,249,0,154,0,215,0,169,0,161,0,0,0,5,0,56,0,11,0,41,0,243,0,178,0,85,0,53,0,147,0,208,0,216,0,200,0,200,0,104,0,13,0,181,0,0,0,138,0,117,0);
signal scenario_full  : scenario_type := (200,31,32,31,217,31,204,31,141,31,141,30,141,29,32,31,74,31,85,31,184,31,184,30,121,31,91,31,132,31,165,31,165,30,165,29,208,31,238,31,238,30,172,31,195,31,30,31,38,31,38,30,203,31,203,30,146,31,147,31,175,31,115,31,185,31,136,31,195,31,194,31,24,31,226,31,173,31,173,30,173,29,198,31,198,30,68,31,100,31,170,31,170,30,31,31,31,30,168,31,214,31,158,31,54,31,136,31,136,30,203,31,179,31,179,30,185,31,13,31,63,31,173,31,173,30,238,31,170,31,210,31,251,31,22,31,22,30,4,31,4,30,4,29,128,31,230,31,106,31,151,31,225,31,187,31,234,31,234,30,77,31,235,31,123,31,12,31,18,31,18,30,18,29,217,31,217,30,226,31,226,30,38,31,38,30,103,31,155,31,152,31,95,31,95,30,95,29,192,31,15,31,15,30,2,31,92,31,230,31,153,31,251,31,129,31,129,30,129,29,119,31,71,31,151,31,40,31,195,31,51,31,163,31,248,31,88,31,88,30,105,31,7,31,79,31,168,31,123,31,198,31,198,30,51,31,51,30,146,31,7,31,209,31,209,30,123,31,33,31,185,31,188,31,188,30,197,31,158,31,18,31,205,31,37,31,69,31,175,31,119,31,119,30,174,31,30,31,107,31,160,31,107,31,1,31,1,30,1,29,142,31,126,31,61,31,21,31,247,31,247,30,162,31,162,30,169,31,169,30,81,31,44,31,65,31,110,31,247,31,247,30,74,31,14,31,125,31,4,31,46,31,122,31,102,31,180,31,94,31,127,31,247,31,247,30,220,31,148,31,4,31,50,31,229,31,146,31,48,31,48,30,23,31,23,30,240,31,215,31,184,31,184,30,236,31,105,31,227,31,164,31,142,31,251,31,185,31,127,31,49,31,147,31,147,30,116,31,6,31,87,31,100,31,187,31,4,31,4,30,120,31,120,30,120,29,20,31,34,31,159,31,159,30,249,31,154,31,215,31,169,31,161,31,161,30,5,31,56,31,11,31,41,31,243,31,178,31,85,31,53,31,147,31,208,31,216,31,200,31,200,31,104,31,13,31,181,31,181,30,138,31,117,31);

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

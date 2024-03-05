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

constant SCENARIO_LENGTH : integer := 266;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (48,0,252,0,178,0,199,0,155,0,0,0,72,0,144,0,0,0,212,0,58,0,163,0,59,0,0,0,119,0,242,0,0,0,123,0,0,0,65,0,0,0,215,0,49,0,177,0,103,0,103,0,122,0,0,0,251,0,44,0,0,0,0,0,171,0,192,0,108,0,0,0,112,0,208,0,123,0,135,0,185,0,0,0,186,0,142,0,84,0,241,0,44,0,86,0,179,0,224,0,0,0,189,0,177,0,211,0,69,0,147,0,0,0,0,0,0,0,0,0,81,0,170,0,87,0,99,0,118,0,21,0,215,0,101,0,162,0,19,0,213,0,0,0,230,0,217,0,0,0,119,0,251,0,122,0,0,0,51,0,164,0,169,0,225,0,125,0,51,0,12,0,246,0,176,0,0,0,7,0,89,0,69,0,140,0,0,0,38,0,242,0,146,0,118,0,142,0,146,0,20,0,56,0,179,0,201,0,172,0,149,0,25,0,162,0,0,0,137,0,37,0,0,0,57,0,34,0,179,0,7,0,232,0,157,0,133,0,253,0,32,0,169,0,100,0,80,0,121,0,91,0,0,0,0,0,61,0,6,0,230,0,49,0,210,0,0,0,189,0,28,0,69,0,204,0,252,0,118,0,255,0,0,0,55,0,0,0,234,0,57,0,0,0,0,0,226,0,105,0,254,0,243,0,148,0,3,0,63,0,0,0,68,0,0,0,90,0,200,0,10,0,235,0,83,0,18,0,213,0,120,0,0,0,239,0,47,0,198,0,0,0,2,0,0,0,196,0,0,0,5,0,81,0,61,0,102,0,159,0,165,0,0,0,177,0,151,0,80,0,224,0,128,0,88,0,66,0,200,0,53,0,202,0,161,0,166,0,120,0,0,0,0,0,40,0,18,0,0,0,179,0,71,0,83,0,0,0,0,0,52,0,23,0,127,0,198,0,211,0,22,0,201,0,222,0,204,0,186,0,0,0,19,0,254,0,222,0,62,0,201,0,11,0,10,0,64,0,0,0,64,0,163,0,154,0,27,0,213,0,68,0,162,0,92,0,160,0,72,0,164,0,80,0,27,0,206,0,41,0,0,0,177,0,207,0,0,0,219,0,65,0,244,0,0,0,252,0,0,0,223,0,71,0,18,0,161,0,153,0,58,0,0,0,39,0,32,0,57,0,150,0,199,0,0,0,183,0,0,0,32,0);
signal scenario_full  : scenario_type := (48,31,252,31,178,31,199,31,155,31,155,30,72,31,144,31,144,30,212,31,58,31,163,31,59,31,59,30,119,31,242,31,242,30,123,31,123,30,65,31,65,30,215,31,49,31,177,31,103,31,103,31,122,31,122,30,251,31,44,31,44,30,44,29,171,31,192,31,108,31,108,30,112,31,208,31,123,31,135,31,185,31,185,30,186,31,142,31,84,31,241,31,44,31,86,31,179,31,224,31,224,30,189,31,177,31,211,31,69,31,147,31,147,30,147,29,147,28,147,27,81,31,170,31,87,31,99,31,118,31,21,31,215,31,101,31,162,31,19,31,213,31,213,30,230,31,217,31,217,30,119,31,251,31,122,31,122,30,51,31,164,31,169,31,225,31,125,31,51,31,12,31,246,31,176,31,176,30,7,31,89,31,69,31,140,31,140,30,38,31,242,31,146,31,118,31,142,31,146,31,20,31,56,31,179,31,201,31,172,31,149,31,25,31,162,31,162,30,137,31,37,31,37,30,57,31,34,31,179,31,7,31,232,31,157,31,133,31,253,31,32,31,169,31,100,31,80,31,121,31,91,31,91,30,91,29,61,31,6,31,230,31,49,31,210,31,210,30,189,31,28,31,69,31,204,31,252,31,118,31,255,31,255,30,55,31,55,30,234,31,57,31,57,30,57,29,226,31,105,31,254,31,243,31,148,31,3,31,63,31,63,30,68,31,68,30,90,31,200,31,10,31,235,31,83,31,18,31,213,31,120,31,120,30,239,31,47,31,198,31,198,30,2,31,2,30,196,31,196,30,5,31,81,31,61,31,102,31,159,31,165,31,165,30,177,31,151,31,80,31,224,31,128,31,88,31,66,31,200,31,53,31,202,31,161,31,166,31,120,31,120,30,120,29,40,31,18,31,18,30,179,31,71,31,83,31,83,30,83,29,52,31,23,31,127,31,198,31,211,31,22,31,201,31,222,31,204,31,186,31,186,30,19,31,254,31,222,31,62,31,201,31,11,31,10,31,64,31,64,30,64,31,163,31,154,31,27,31,213,31,68,31,162,31,92,31,160,31,72,31,164,31,80,31,27,31,206,31,41,31,41,30,177,31,207,31,207,30,219,31,65,31,244,31,244,30,252,31,252,30,223,31,71,31,18,31,161,31,153,31,58,31,58,30,39,31,32,31,57,31,150,31,199,31,199,30,183,31,183,30,32,31);

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

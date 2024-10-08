-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_347 is
end project_tb_347;

architecture project_tb_arch_347 of project_tb_347 is
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

constant SCENARIO_LENGTH : integer := 347;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (40,0,20,0,203,0,211,0,0,0,229,0,63,0,115,0,0,0,0,0,0,0,186,0,13,0,0,0,0,0,55,0,72,0,0,0,40,0,244,0,28,0,253,0,176,0,31,0,187,0,233,0,18,0,160,0,0,0,125,0,21,0,201,0,140,0,0,0,63,0,125,0,11,0,228,0,196,0,41,0,72,0,154,0,0,0,206,0,30,0,62,0,99,0,202,0,213,0,202,0,24,0,0,0,0,0,200,0,97,0,0,0,199,0,0,0,0,0,170,0,113,0,0,0,235,0,197,0,141,0,42,0,31,0,91,0,226,0,0,0,238,0,151,0,85,0,145,0,39,0,237,0,30,0,238,0,0,0,252,0,0,0,0,0,0,0,123,0,100,0,0,0,54,0,0,0,183,0,154,0,45,0,0,0,144,0,38,0,0,0,28,0,0,0,115,0,122,0,141,0,58,0,210,0,10,0,12,0,237,0,79,0,41,0,0,0,137,0,22,0,0,0,32,0,135,0,74,0,119,0,78,0,237,0,0,0,25,0,120,0,203,0,189,0,0,0,210,0,103,0,122,0,144,0,0,0,236,0,60,0,87,0,223,0,0,0,227,0,203,0,196,0,240,0,146,0,141,0,187,0,250,0,246,0,200,0,100,0,221,0,121,0,135,0,182,0,113,0,73,0,230,0,13,0,0,0,0,0,202,0,119,0,150,0,53,0,250,0,195,0,130,0,61,0,74,0,215,0,149,0,71,0,233,0,0,0,0,0,0,0,0,0,4,0,0,0,40,0,0,0,174,0,236,0,0,0,27,0,120,0,217,0,0,0,0,0,0,0,22,0,68,0,239,0,149,0,210,0,26,0,134,0,0,0,75,0,0,0,114,0,218,0,0,0,175,0,253,0,251,0,32,0,0,0,0,0,0,0,0,0,193,0,187,0,220,0,70,0,0,0,190,0,36,0,69,0,83,0,48,0,65,0,197,0,87,0,156,0,0,0,169,0,0,0,39,0,0,0,131,0,187,0,230,0,116,0,169,0,126,0,190,0,0,0,0,0,175,0,94,0,141,0,0,0,0,0,0,0,0,0,112,0,0,0,201,0,161,0,0,0,88,0,230,0,254,0,8,0,193,0,18,0,62,0,0,0,2,0,171,0,0,0,216,0,91,0,0,0,0,0,0,0,78,0,191,0,118,0,0,0,0,0,102,0,62,0,190,0,64,0,0,0,115,0,79,0,163,0,181,0,69,0,96,0,107,0,0,0,0,0,221,0,234,0,104,0,194,0,198,0,204,0,82,0,22,0,162,0,250,0,6,0,193,0,169,0,127,0,103,0,135,0,0,0,117,0,188,0,0,0,0,0,0,0,217,0,99,0,0,0,114,0,206,0,0,0,0,0,215,0,106,0,168,0,251,0,164,0,51,0,0,0,0,0,180,0,94,0,0,0,168,0,202,0,157,0,118,0,0,0,0,0,104,0,253,0,9,0,188,0,0,0,0,0,168,0,33,0,151,0,146,0,153,0,111,0,17,0,44,0,56,0,86,0,180,0,50,0,177,0,86,0,219,0);
signal scenario_full  : scenario_type := (40,31,20,31,203,31,211,31,211,30,229,31,63,31,115,31,115,30,115,29,115,28,186,31,13,31,13,30,13,29,55,31,72,31,72,30,40,31,244,31,28,31,253,31,176,31,31,31,187,31,233,31,18,31,160,31,160,30,125,31,21,31,201,31,140,31,140,30,63,31,125,31,11,31,228,31,196,31,41,31,72,31,154,31,154,30,206,31,30,31,62,31,99,31,202,31,213,31,202,31,24,31,24,30,24,29,200,31,97,31,97,30,199,31,199,30,199,29,170,31,113,31,113,30,235,31,197,31,141,31,42,31,31,31,91,31,226,31,226,30,238,31,151,31,85,31,145,31,39,31,237,31,30,31,238,31,238,30,252,31,252,30,252,29,252,28,123,31,100,31,100,30,54,31,54,30,183,31,154,31,45,31,45,30,144,31,38,31,38,30,28,31,28,30,115,31,122,31,141,31,58,31,210,31,10,31,12,31,237,31,79,31,41,31,41,30,137,31,22,31,22,30,32,31,135,31,74,31,119,31,78,31,237,31,237,30,25,31,120,31,203,31,189,31,189,30,210,31,103,31,122,31,144,31,144,30,236,31,60,31,87,31,223,31,223,30,227,31,203,31,196,31,240,31,146,31,141,31,187,31,250,31,246,31,200,31,100,31,221,31,121,31,135,31,182,31,113,31,73,31,230,31,13,31,13,30,13,29,202,31,119,31,150,31,53,31,250,31,195,31,130,31,61,31,74,31,215,31,149,31,71,31,233,31,233,30,233,29,233,28,233,27,4,31,4,30,40,31,40,30,174,31,236,31,236,30,27,31,120,31,217,31,217,30,217,29,217,28,22,31,68,31,239,31,149,31,210,31,26,31,134,31,134,30,75,31,75,30,114,31,218,31,218,30,175,31,253,31,251,31,32,31,32,30,32,29,32,28,32,27,193,31,187,31,220,31,70,31,70,30,190,31,36,31,69,31,83,31,48,31,65,31,197,31,87,31,156,31,156,30,169,31,169,30,39,31,39,30,131,31,187,31,230,31,116,31,169,31,126,31,190,31,190,30,190,29,175,31,94,31,141,31,141,30,141,29,141,28,141,27,112,31,112,30,201,31,161,31,161,30,88,31,230,31,254,31,8,31,193,31,18,31,62,31,62,30,2,31,171,31,171,30,216,31,91,31,91,30,91,29,91,28,78,31,191,31,118,31,118,30,118,29,102,31,62,31,190,31,64,31,64,30,115,31,79,31,163,31,181,31,69,31,96,31,107,31,107,30,107,29,221,31,234,31,104,31,194,31,198,31,204,31,82,31,22,31,162,31,250,31,6,31,193,31,169,31,127,31,103,31,135,31,135,30,117,31,188,31,188,30,188,29,188,28,217,31,99,31,99,30,114,31,206,31,206,30,206,29,215,31,106,31,168,31,251,31,164,31,51,31,51,30,51,29,180,31,94,31,94,30,168,31,202,31,157,31,118,31,118,30,118,29,104,31,253,31,9,31,188,31,188,30,188,29,168,31,33,31,151,31,146,31,153,31,111,31,17,31,44,31,56,31,86,31,180,31,50,31,177,31,86,31,219,31);

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

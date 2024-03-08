-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_966 is
end project_tb_966;

architecture project_tb_arch_966 of project_tb_966 is
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

constant SCENARIO_LENGTH : integer := 322;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,38,0,68,0,4,0,139,0,112,0,0,0,183,0,157,0,80,0,103,0,70,0,94,0,0,0,150,0,0,0,53,0,98,0,168,0,182,0,101,0,19,0,38,0,162,0,74,0,0,0,0,0,23,0,0,0,211,0,109,0,223,0,192,0,128,0,218,0,0,0,247,0,131,0,38,0,107,0,114,0,108,0,0,0,112,0,32,0,37,0,92,0,77,0,224,0,47,0,23,0,200,0,199,0,146,0,56,0,25,0,0,0,224,0,6,0,212,0,0,0,23,0,105,0,157,0,217,0,209,0,234,0,64,0,247,0,0,0,159,0,0,0,106,0,0,0,1,0,145,0,25,0,0,0,30,0,0,0,213,0,0,0,236,0,185,0,248,0,0,0,216,0,18,0,0,0,16,0,0,0,124,0,0,0,8,0,204,0,111,0,5,0,13,0,0,0,0,0,0,0,0,0,0,0,0,0,245,0,230,0,162,0,253,0,40,0,0,0,105,0,23,0,0,0,183,0,213,0,75,0,134,0,5,0,66,0,0,0,106,0,232,0,0,0,193,0,0,0,77,0,140,0,0,0,222,0,0,0,154,0,221,0,0,0,88,0,89,0,189,0,121,0,0,0,6,0,86,0,140,0,228,0,0,0,239,0,238,0,224,0,0,0,6,0,0,0,222,0,247,0,82,0,62,0,197,0,51,0,188,0,107,0,145,0,1,0,160,0,174,0,75,0,0,0,129,0,250,0,253,0,223,0,68,0,232,0,48,0,0,0,0,0,234,0,244,0,103,0,113,0,42,0,156,0,217,0,126,0,160,0,0,0,175,0,0,0,9,0,254,0,228,0,0,0,151,0,245,0,0,0,30,0,147,0,137,0,106,0,175,0,0,0,195,0,0,0,97,0,12,0,144,0,0,0,0,0,109,0,196,0,150,0,0,0,168,0,0,0,230,0,104,0,173,0,155,0,0,0,0,0,223,0,53,0,108,0,83,0,81,0,0,0,0,0,0,0,109,0,0,0,98,0,139,0,251,0,68,0,235,0,202,0,0,0,0,0,187,0,0,0,108,0,192,0,188,0,124,0,212,0,211,0,144,0,31,0,156,0,174,0,0,0,208,0,136,0,161,0,225,0,156,0,88,0,0,0,254,0,125,0,0,0,126,0,165,0,53,0,0,0,0,0,44,0,230,0,187,0,169,0,83,0,16,0,215,0,231,0,239,0,118,0,0,0,170,0,201,0,228,0,196,0,1,0,96,0,0,0,58,0,126,0,74,0,197,0,169,0,94,0,0,0,233,0,151,0,237,0,189,0,71,0,0,0,166,0,107,0,26,0,37,0,106,0,186,0,0,0,56,0,53,0,216,0,210,0,192,0,0,0,0,0,0,0,34,0,28,0,0,0,140,0,122,0,0,0,205,0,87,0,151,0,31,0,214,0,77,0,29,0,62,0);
signal scenario_full  : scenario_type := (0,0,38,31,68,31,4,31,139,31,112,31,112,30,183,31,157,31,80,31,103,31,70,31,94,31,94,30,150,31,150,30,53,31,98,31,168,31,182,31,101,31,19,31,38,31,162,31,74,31,74,30,74,29,23,31,23,30,211,31,109,31,223,31,192,31,128,31,218,31,218,30,247,31,131,31,38,31,107,31,114,31,108,31,108,30,112,31,32,31,37,31,92,31,77,31,224,31,47,31,23,31,200,31,199,31,146,31,56,31,25,31,25,30,224,31,6,31,212,31,212,30,23,31,105,31,157,31,217,31,209,31,234,31,64,31,247,31,247,30,159,31,159,30,106,31,106,30,1,31,145,31,25,31,25,30,30,31,30,30,213,31,213,30,236,31,185,31,248,31,248,30,216,31,18,31,18,30,16,31,16,30,124,31,124,30,8,31,204,31,111,31,5,31,13,31,13,30,13,29,13,28,13,27,13,26,13,25,245,31,230,31,162,31,253,31,40,31,40,30,105,31,23,31,23,30,183,31,213,31,75,31,134,31,5,31,66,31,66,30,106,31,232,31,232,30,193,31,193,30,77,31,140,31,140,30,222,31,222,30,154,31,221,31,221,30,88,31,89,31,189,31,121,31,121,30,6,31,86,31,140,31,228,31,228,30,239,31,238,31,224,31,224,30,6,31,6,30,222,31,247,31,82,31,62,31,197,31,51,31,188,31,107,31,145,31,1,31,160,31,174,31,75,31,75,30,129,31,250,31,253,31,223,31,68,31,232,31,48,31,48,30,48,29,234,31,244,31,103,31,113,31,42,31,156,31,217,31,126,31,160,31,160,30,175,31,175,30,9,31,254,31,228,31,228,30,151,31,245,31,245,30,30,31,147,31,137,31,106,31,175,31,175,30,195,31,195,30,97,31,12,31,144,31,144,30,144,29,109,31,196,31,150,31,150,30,168,31,168,30,230,31,104,31,173,31,155,31,155,30,155,29,223,31,53,31,108,31,83,31,81,31,81,30,81,29,81,28,109,31,109,30,98,31,139,31,251,31,68,31,235,31,202,31,202,30,202,29,187,31,187,30,108,31,192,31,188,31,124,31,212,31,211,31,144,31,31,31,156,31,174,31,174,30,208,31,136,31,161,31,225,31,156,31,88,31,88,30,254,31,125,31,125,30,126,31,165,31,53,31,53,30,53,29,44,31,230,31,187,31,169,31,83,31,16,31,215,31,231,31,239,31,118,31,118,30,170,31,201,31,228,31,196,31,1,31,96,31,96,30,58,31,126,31,74,31,197,31,169,31,94,31,94,30,233,31,151,31,237,31,189,31,71,31,71,30,166,31,107,31,26,31,37,31,106,31,186,31,186,30,56,31,53,31,216,31,210,31,192,31,192,30,192,29,192,28,34,31,28,31,28,30,140,31,122,31,122,30,205,31,87,31,151,31,31,31,214,31,77,31,29,31,62,31);

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

-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_295 is
end project_tb_295;

architecture project_tb_arch_295 of project_tb_295 is
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

constant SCENARIO_LENGTH : integer := 307;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (155,0,64,0,239,0,0,0,166,0,85,0,111,0,40,0,55,0,83,0,0,0,0,0,88,0,229,0,96,0,179,0,76,0,129,0,48,0,255,0,120,0,0,0,199,0,99,0,0,0,36,0,170,0,0,0,200,0,83,0,234,0,91,0,0,0,232,0,125,0,250,0,51,0,136,0,16,0,0,0,194,0,145,0,55,0,48,0,0,0,205,0,18,0,181,0,97,0,37,0,45,0,192,0,64,0,243,0,65,0,169,0,220,0,187,0,0,0,211,0,16,0,0,0,84,0,205,0,253,0,0,0,182,0,87,0,0,0,224,0,0,0,129,0,0,0,235,0,0,0,0,0,25,0,232,0,248,0,67,0,21,0,0,0,209,0,60,0,0,0,248,0,21,0,111,0,175,0,193,0,157,0,0,0,38,0,66,0,99,0,0,0,32,0,238,0,221,0,202,0,0,0,190,0,172,0,182,0,208,0,176,0,0,0,165,0,222,0,0,0,183,0,26,0,11,0,0,0,71,0,224,0,134,0,166,0,87,0,54,0,15,0,18,0,66,0,80,0,0,0,68,0,0,0,86,0,211,0,0,0,15,0,81,0,0,0,39,0,0,0,100,0,24,0,118,0,118,0,236,0,0,0,0,0,8,0,0,0,236,0,136,0,80,0,216,0,1,0,75,0,214,0,186,0,0,0,87,0,0,0,157,0,80,0,179,0,173,0,190,0,58,0,27,0,79,0,191,0,235,0,0,0,176,0,50,0,24,0,0,0,145,0,1,0,32,0,205,0,0,0,0,0,87,0,115,0,94,0,137,0,224,0,161,0,115,0,248,0,178,0,166,0,106,0,34,0,225,0,213,0,184,0,36,0,0,0,85,0,135,0,161,0,209,0,85,0,201,0,31,0,64,0,216,0,30,0,0,0,168,0,157,0,162,0,123,0,109,0,2,0,130,0,134,0,225,0,136,0,74,0,195,0,12,0,75,0,194,0,53,0,0,0,162,0,178,0,226,0,122,0,219,0,12,0,166,0,95,0,130,0,0,0,99,0,0,0,16,0,34,0,142,0,219,0,53,0,0,0,211,0,134,0,187,0,0,0,240,0,253,0,159,0,0,0,117,0,78,0,126,0,170,0,218,0,51,0,0,0,0,0,163,0,42,0,117,0,92,0,20,0,9,0,60,0,224,0,248,0,0,0,0,0,188,0,30,0,124,0,209,0,142,0,0,0,181,0,194,0,209,0,138,0,200,0,232,0,5,0,36,0,13,0,0,0,138,0,179,0,182,0,129,0,58,0,197,0,122,0,0,0,0,0,140,0,0,0,216,0,206,0,244,0,200,0,98,0,0,0,0,0,32,0,3,0,65,0,239,0,148,0,157,0,40,0);
signal scenario_full  : scenario_type := (155,31,64,31,239,31,239,30,166,31,85,31,111,31,40,31,55,31,83,31,83,30,83,29,88,31,229,31,96,31,179,31,76,31,129,31,48,31,255,31,120,31,120,30,199,31,99,31,99,30,36,31,170,31,170,30,200,31,83,31,234,31,91,31,91,30,232,31,125,31,250,31,51,31,136,31,16,31,16,30,194,31,145,31,55,31,48,31,48,30,205,31,18,31,181,31,97,31,37,31,45,31,192,31,64,31,243,31,65,31,169,31,220,31,187,31,187,30,211,31,16,31,16,30,84,31,205,31,253,31,253,30,182,31,87,31,87,30,224,31,224,30,129,31,129,30,235,31,235,30,235,29,25,31,232,31,248,31,67,31,21,31,21,30,209,31,60,31,60,30,248,31,21,31,111,31,175,31,193,31,157,31,157,30,38,31,66,31,99,31,99,30,32,31,238,31,221,31,202,31,202,30,190,31,172,31,182,31,208,31,176,31,176,30,165,31,222,31,222,30,183,31,26,31,11,31,11,30,71,31,224,31,134,31,166,31,87,31,54,31,15,31,18,31,66,31,80,31,80,30,68,31,68,30,86,31,211,31,211,30,15,31,81,31,81,30,39,31,39,30,100,31,24,31,118,31,118,31,236,31,236,30,236,29,8,31,8,30,236,31,136,31,80,31,216,31,1,31,75,31,214,31,186,31,186,30,87,31,87,30,157,31,80,31,179,31,173,31,190,31,58,31,27,31,79,31,191,31,235,31,235,30,176,31,50,31,24,31,24,30,145,31,1,31,32,31,205,31,205,30,205,29,87,31,115,31,94,31,137,31,224,31,161,31,115,31,248,31,178,31,166,31,106,31,34,31,225,31,213,31,184,31,36,31,36,30,85,31,135,31,161,31,209,31,85,31,201,31,31,31,64,31,216,31,30,31,30,30,168,31,157,31,162,31,123,31,109,31,2,31,130,31,134,31,225,31,136,31,74,31,195,31,12,31,75,31,194,31,53,31,53,30,162,31,178,31,226,31,122,31,219,31,12,31,166,31,95,31,130,31,130,30,99,31,99,30,16,31,34,31,142,31,219,31,53,31,53,30,211,31,134,31,187,31,187,30,240,31,253,31,159,31,159,30,117,31,78,31,126,31,170,31,218,31,51,31,51,30,51,29,163,31,42,31,117,31,92,31,20,31,9,31,60,31,224,31,248,31,248,30,248,29,188,31,30,31,124,31,209,31,142,31,142,30,181,31,194,31,209,31,138,31,200,31,232,31,5,31,36,31,13,31,13,30,138,31,179,31,182,31,129,31,58,31,197,31,122,31,122,30,122,29,140,31,140,30,216,31,206,31,244,31,200,31,98,31,98,30,98,29,32,31,3,31,65,31,239,31,148,31,157,31,40,31);

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
